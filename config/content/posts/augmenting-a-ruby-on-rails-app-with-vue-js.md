---
date: "2016-09-07"
title: Augmenting a Ruby on Rails App with Vue.js
summary: A lightweight approach to integrating Vue.js into a Ruby on Rails application.
tags:
  - vue
  - rails
  - javascript
  - coffeescript
---

Building apps using standard Ruby on Rails templates is fantastic - for the most part. If one subscribes to the "Sprinkling of JavaScript" philosophy it is possible to build and iterate on features at a surprisingly quick tempo. If not - one still might think regular old Ruby on Rails forms are useful.

What happens when a custom form element is needed? How about integrating with a third party JavaScript SDK to handle an API call? What about happens 'Sprinkles' of JavaScript start to look more like 'Piles' and 'Mounds'? Using jQuery plus data attributes inevitably becomes unmanageable. [Angular.js](https://angularjs.org/) and [Ember.js](http://emberjs.com/) are nice - but they often seem all consuming. A perhaps overlooked alternative is [Vue.js](https://vuejs.org/) - a reactive and component driven framework that easily integrates with apps that serve side rendering.

To demonstrate why [Vue.js](https://vuejs.org/) is a great option for augmenting a mostly server side app this article tackles a problem that many (profitable) startups eventually need to solve: processing payments. For simplicity - this tutorial focuses on a part of that feature - securely collecting and tokenizing a credit card (via Stripe - although integrating with other payment gateways follows a similar workflow). Some knowledge of [CoffeeScript](http://coffeescript.org/) is presumed - but the pattern does not require it.

# Setting Up The App

To kick things off:

```bash
rails new sample
cd sample
```

Then the following dependencies can be added to the `Gemfile`:

**Gemfile**

```ruby
source 'https://rails-assets.org' do
  gem 'rails-assets-vue'
  gem 'rails-assets-jquery.payment'
end
```

```bash
bundle
```

Next `config/stripe.yml` and `config/initializers/stripe.rb` can be setup to initialize Stripe (test keys can be used instead of `...` - production keys should only be set via the `ENV` variables):

**config/stripe.yml**

```yaml
defaults: &defaults
  publishable_key: <%= ENV['STRIPE_PUBLISHABLE_KEY'] || '...' %>
  secret_key: <%= ENV['STRIPE_SECRET_KEY'] || '...' %>

development:
  <<: *defaults

test:
  <<: *defaults

production:
  <<: *defaults
```

**config/initializer/stripe.rb**

```ruby
config = YAML::load(ERB.new(File.read("#{Rails.root}/config/stripe.yml")).result)[Rails.env]
Rails.configuration.x.stripe.publishable_key = config['publishable_key']
Rails.configuration.x.stripe.secret_key = config['secret_key']

Stripe.api_key = Rails.configuration.x.stripe.secret_key
```

With the dependencies in place the `application.js` and `application.css` files can be modified to require all the basic dependencies of the sample app:

**app/assets/javascripts/application.js**

```javascript
//= require turbolinks
//= require jquery
//= require jquery.payment
//= require jquery_ujs
//= require bootstrap
//= require vue
//= require ./main
```

**app/assets/stylesheets/application.css**

```css
/**
 *= require bootstrap
 */
```

Then the the default layout can be modified. Notice the ordering of the includes / links, the meta tag, and the 'application' `id` attached to the `html` tag.

**app/views/layouts/application.html.erb**

```erb
<!DOCTYPE html>
<html id="application">
<head>
  <%= tag :meta, name: "stripe-publishable-key", content: Rails.configuration.x.stripe.publishable_key %>

  <%= javascript_include_tag "https://js.stripe.com/v2/" %>

  <%= javascript_include_tag "application", "data-turbolinks-track": "reload" %>
  <%= stylesheet_link_tag "application", "data-turbolinks-track": "reload" %>

  <%= csrf_meta_tags %>
</head>
<body>
  <div class="container">
    <%= yield %>
  </div>
</body>
</html>
```

Some configuration is needed. `app/assets/javascripts/directives` and `app/assets/javascripts/components` folders are required (they can be empty) then a `main.coffee` file handles the requires and configuring Vue.js and Stripe.js. Notice the `el` is the same `id` as specified in the layout and the `stripe-publishable-key` is taken from the `meta` tag.

**app/assets/javascripts/main.coffee**

```coffeescript
#= require_tree ./components
#= require_tree ./directives

Stripe.setPublishableKey($('meta[name="stripe-publishable-key"]').attr('content'))
$(document).on "turbolinks:load", -> new Vue(el: "#application")
```

At this point the sample app should startup without any issues using `rails server`.

# The Standard Rails Portion

A basic checkout model and controller are going to form the core of the application. The `Checkout` model takes in a `source` - a token that is collected by [Stripe.js](https://stripe.com/docs/stripe.js) and applies a charge. A form is added for entering the number, cvc, and expiration of the card. This information is not sent to the server (instead a tokenized copy of the card is sent).

**app/models/checkout.rb**

```ruby
class Checkout
  include ActiveModel::Model

  attr_accessor :source

  def initialize(attributes = {})
    self.source = attributes[:source]
  end

  def process(amount: 99, currency: "usd")
    Stripe::Charge.create(amount: amount, currency: currency, source: source)
  end
end
```

**app/controllers/checkouts_controller.rb**

```ruby
class CheckoutsController < ApplicationController

  def new
    @checkout = Checkout.new

    respond_to do |format|
      format.html
    end
  end

  def create
    @checkout = Checkout.new(params.require(:checkout).permit(:source))
    @checkout.process

    respond_to do |format|
      format.html { redirect_to root_path }
    end
  end

end
```

**config/routes.rb**

```ruby
Rails.application.routes.draw do
  resource :checkout, only: %i(new create)
end
```

**app/views/checkouts/new.html.erb**

```erb
<%= form_for @checkout, url: checkout_path, class: "form-group" do |form| %>
  <%= form.hidden_field :source %>

  <div class="form-group">
    <input class="form-control" type="text" placeholder="Name" />
  </div>

  <div class="form-group">
    <input class="form-control" type="text" placeholder="Number" />
  </div>

  <div class="form-group">
    <input class="form-control" type="text" placeholder="Expiration" />
  </div>

  <div class="form-group">
    <input class="form-control" type="text" placeholder="CVC" />
  </div>

  <%= form.submit "Checkout", class: 'btn' %>
<% end %>
```

At this point the sample app has a `/checkout/new` endpoint with a basic form. Submitting the form (with or without data) raises an error that the source is blank (which is expected). The form does not send the number or CVC to the server.

# Wiring Up A Component

[Components](https://vuejs.org/guide/essentials/component-basics) are a core features of Vue.js. Typically components contain a template - (but they do not have to). For this sample app a component with an `inline-template` is used.

For the sample app a `checkout` component will handle the the tokenization of the card and subsequent submitting of the form. The component will have a data function (that initializes the values when the component loads) and a submit method (that is bound to our form submit). The markup for the checkout form is modified to contain binding to the submit method [v-on](https://vuejs.org/api/#v-on) and binding of the checkout attributes [v-model](https://vuejs.org/api/#v-model). A special errors key is added for validations that gets displayed using [v-if](https://vuejs.org/api/#v-if).

**app/assets/javascripts/components/checkout.coffee**

```coffeescript
Vue.component 'checkout', Vue.extend

  data: ->
    errors: {}
    number: null
    exp: null
    cvc: null

    methods:
      submit: ->
        @errors =
          number: ("cannot be blank" if !@number? or @number is "")
          exp: ("cannot be blank" if !@exp? or @exp is "")
          cvc: ("cannot be blank" if !@cvc? or @cvc is "")
        unless @errors.number or @errors.exp or @errors.cvc
          card =
            number: @number
            exp: @exp
            cvc: @cvc
          Stripe.card.createToken card, (status, response) =>
            if response.error?
              @errors = base: response.error.message
            else
              @$els.token.value = response.id
              @$els.form.submit()
```

**app/views/checkouts/new.html.erb**

```erb
<checkout inline-template>
  <%= form_for @checkout, url: checkout_path, class: "form-group",
    html: { "v-on:submit.stop.prevent": "submit" } do |form| %>

    <div class="alert alert-danger" role="alert" v-if="errors.base">{{ errors.base }}</div>

    <div class="form-group" :class="{ 'has-danger': errors.number }">
      <input class="form-control" type="text" placeholder="Number" v-model="number"
        :class="{ 'form-control-danger': errors.number }" />
      <div class="form-control-feedback" v-if="errors.number" v-cloak>{{ errors.number }}</div>
    </div>

    <div class="form-group" :class="{ 'has-danger': errors.cvc }">
      <input class="form-control" type="text" placeholder="CVC" v-model="cvc"
        :class="{ 'form-control-danger': errors.cvc }" />
      <div class="form-control-feedback" v-if="errors.cvc" v-cloak>{{ errors.cvc }}</div>
    </div>

    <div class="form-group" :class="{ 'has-danger': errors.exp }">
      <input class="form-control" type="text" placeholder="Expiration" v-model="exp"
        :class="{ 'form-control-danger': errors.exp }" />
      <div class="form-control-feedback" v-if="errors.exp" v-cloak>{{ errors.exp }}</div>
    </div>

    <%= form.submit "Checkout", class: 'btn' %>
  <% end %>
</checkout>
```

At this point the sample app's `/checkout/new` endpoint works. If any of the fields are blank inline errors appear. If the card is invalid a global error appears. If everything is valid the form is submitted and a charge is placed.

# Wiring Up A Directive

[Directives](https://vuejs.org/guide/custom-directive.html) are another core features of Vue.js. Vue.js ships with a number of standard directives (all the custom properties like `v-model`, `v-if` and `v-on` are directives).

The sample will use a `payment` directive that integrates with the [jQuery.payment](https://stripe.com/blog/jquery-payment) to format the card inputs. This is done by registering a directive with methods for `bind` and `unbind` (that add and remove the jQuery.payment snippets).

**app/assets/javascripts/directives/payment.coffee**

```ruby
Vue.directive "payment",

  bind: (value) ->
    method = switch @expression
      when "format-card-number" then "formatCardNumber"
      when "format-card-exp" then "formatCardExpiry"
      when "format-card-cvc" then "formatCardCVC"
    $(@el).payment(method)

  unbind: ->
    $(@el).unbind()
```

**app/views/checkouts/new.html.erb**

```erb
<input class="form-control" type="text" placeholder="Number"
  v-payment="format-card-number" v-model="number"
  :class="{ 'form-control-danger': errors.number }" />

<input class="form-control" type="text" placeholder="CVC"
  v-payment="format-card-cvc" v-model="cvc"
  :class="{ 'form-control-danger': errors.cvc }" />

<input class="form-control" type="text" placeholder="Expiration"
  v-payment="format-card-expiration" v-model="exp"
  :class="{ 'form-control-danger': errors.exp }" />
```

# The Wrap Up

A fully functioning checkout requires carts / orders / etc - none of which are explored in this tutorial. It is also one of the most important components of an application to properly test (of which none is done here). Finally more advanced validations are easily availability for the form (but excluded for brevity). However - the pattern of using Vue.js to augment forms or views (via components) and individual DOM elements (via directives) reactively is a promising approach to augmenting Ruby on Rails apps.
