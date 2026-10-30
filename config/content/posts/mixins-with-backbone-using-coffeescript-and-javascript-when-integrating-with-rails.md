---
date: "2014-12-14"
title: Mixins With Backbone Using CoffeeScript and JavaScript When Integrating With Rails
summary: A quick introduction to using mixins with Backbone to extract out common code
tags:
  - coffeescript
  - javascript
  - backbone
  - rails
---

One of the more powerful feature of Ruby is adding a modules methods to an existing class using either **extend** and **include**. For example:

```ruby
module Sortable
  extend ActiveSupport::Concern

  included do
    scope (:ordered), -> { order(:priority) }

    def self.sort(params)
      self.transaction do
        params.each_with_index do |id, index|
          self.find(id).update(priority: index.next)
        end
      end
    end
  end

end
```

```ruby
class Task < ActiveRecord::Base
  include Sortable
end
```

```bash
rails console
```

```ruby
Task.sort([1,3,2])
  # BEGIN
  # UPDATE tasks SET priority = 1 WHERE id = 1;
  # UPDATE tasks SET priority = 2 WHERE id = 3;
  # UPDATE tasks SET priority = 3 WHERE id = 2;
  # COMMIT
```

Similar functionality is also available in JavaScript / CoffeeScript, but requires a bit of setup.

# Setup

To get started create the following file **mixins/base/mixin.js.coffee**:

```coffeescript
App.Mixin =

  extend: (mixin) ->
    for key, value of mixin when key not in ['extend','include']
      @[key] = value
    mixin.extended?.apply(@)
    return @

  include: (mixin) ->
    for key, value of mixin when key not in ['extend','include']
      @::[key] = value
    mixin.included?.apply(@)
    return @
```

This 'mixin' can be added with [Underscore JS](http://underscorejs.org/) using _extend_ to Backbone routers, models, collections, or views:

```coffeescript
class App.Router extends Backbone.Router
  present: (view) ->
    App.view.remove() if App.view?
    App.view = view
    $('#container').html(view.el)
    view.render()

_.extend App.Router, App.Mixins
```

```coffeescript
class App.View extends Backbone.View
_.extend App.View, App.Mixins
```

```coffeescript
class App.Model extends Backbone.Model
_.extend App.Model, App.Mixins
```

```coffeescript
class App.Collection extends Backbone.Collection
_.extend App.Collection, App.Mixins
```

# Example

Now that the **extend** and **include** methods have been added to our basic models, collections and views they can be used to extract out common code. To start create a basic task app by:

Adding **app/assets/javascripts/application/models/task.js.coffee**:

```coffeescript
class App.Models.Task extends App.Model
  defaults:
    notes: null

  url: -> if @id? then "/tasks/#{@id}" else "/tasks"
```

Then **app/assets/javascripts/application/routers/tasks.js.coffee**:

```coffeescript
class App.Routers.Tasks extends App.Router
  routes:
    "tasks/new" : "new"

  new: ->
    model = new App.Models.Tasks
    view = new App.Views.Tasks.New(model: model)
    view.present()
```

Then **app/assets/javascripts/application/views/tasks/new.js.coffee**:

```coffeescript
class App.Views.Tasks.New extends App.View
  template: HanldebarsTemplates['tasks/new']

  render: ->
    @$el.html(@template())
```

Then **app/assets/javascripts/application/templates/tasks/new.hamlbars**:

```haml
%form
  .alert
  .field.notes
    %input{ type: 'text', name: 'notes' }
    .error
  %button.save Save
  %span.processing{ style: 'display:none' } ...
```

At this point a form helper can be added **app/assets/javascripts/application/helpers/form.js.coffee**:

```coffeescript
class App.Helpers.Form

  constructor: (view) ->
    @view = view

  $: (selector) ->
    @view.$(selector)

  submit: ->
    @process() unless @processing()

  process: ->
    @reset()
    unless @save()
      for field, message of @model.errors
        @$(".#{field} .error").text(message)
    return

  reset: ->
    @$('.error').empty()
    @$('.processing').show()
    return

  save: ->
    @view.model.save @parameters(),
      success: _.bind(@success, @)
      error: _.bind(@error, @)

  parameters: ->
    parameters = {}
    for attr in @view.attrs
      parameters[attr] = @$("[name='#{attr}']").val()
    return parameters

  success: (model, response, options) ->
    @$('.processing').hide()
    @$('.alert').text("Hurrah, your changes have been saved!")
    return

  error: (model, response, options) ->
    @$('.processing').hide()
    @$('.alert').text("Whoops, it looks like something went wrong!")
    return

  processing: ->
    @$('.processing').is(":visible")
```

Finally the mixin can be added **app/assets/javascripts/application/mixins/form.js.coffee**:

```coffeescript
App.Mixins.Form =

  events:
    'submit': 'submit'

  submit: (event) ->
    event.preventDefault()
    event.stopPropagation()
    new App.Helpers.Form(@).submit()
    return
```

Now the view can be modified to **include** the mixin **app/assets/javascripts/application/views/tasks/new.js.coffee**:

```coffeescript
class App.Views.Tasks.New extends App.View
  @include App.Mixins.Form
  template: HandlebarsTemplates['tasks/new']
  attrs: ['notes']

  render: ->
    @$el.html(@template())
```

And that's it! For every subsequent form that is added to the project all that needs to be done is include the **App.Mixins.Form**.

# Caveats

Mixins are fantastic, but do come with a few caveats. In this example, the majority of code was extracted into a helper (breaking the Law of Demeter). However, this is a common practice for mixins to fully encapsulate functionality. This also ensures that the objects prototype isn't polluted and provides a form of name spacing to the helper methods.
