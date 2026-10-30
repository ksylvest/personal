---
date: "2014-11-26"
title: Setup a Clean Backbone JS App With Rails
summary: A basic introduction on how to setup a new Rails project with Backbone JS
---

[Backbone JS](http://backbonejs.org/) is a minimal framework that can be easily integrated into Rails projects. This guide includes some best practices and ideas learned after setting up and working with Backbone for two years on both small and larger projects. Backbone is less convention based than Rails, so use this tutorial as good starting point to develop your own best practices. If you don't know Rails this guide can still be useful (many of the conventions are front end and can be cloned to other frameworks), but some Ruby code is included. This guide also uses [CoffeeScript](http://coffeescript.org/) - a fantastic language that compiles into JavaScript.

# Setup

To get started add the following gems to your project:

```ruby
gem 'backbone-on-rails'
gem 'handlebars_assets'
gem 'hamlbars'
```

Alternatively the assets can be included by downloading and adding the following JS files under **vendor/assets/javascripts** folder:

- [backbone.js](http://backbonejs.org/backbone.js)
- [underscore.js](http://underscorejs.org/underscore.js)
- [handlebars.js](http://handlebarsjs.com/)

# Structure

Once the gems are included (and **bundle** is run), create the following directory structure:

    |--app/assets/
    |----javascripts/
    |------application.js
    |------application/
    |--------app.coffee
    |--------helpers/
    |--------templates/
    |--------mixins/
    |----------base/mixin.coffee
    |--------models/
    |----------base/model.coffee
    |--------collections/
    |----------base/collection.coffee
    |--------routers/
    |----------base/router.coffee
    |--------views/
    |----------base/view.coffee

In **app/assets/javascripts/application.js**:

```javascript
//= require jquery
//= require jquery_ujs
//= require underscore
//= require backbone
//= require handlebars

//= require application/app
```

In **app/assets/javascripts/application/app.coffee**:

```coffeescript
#= require_self

#= require_tree ./helpers
#= require_tree ./templates

#= require ./mixins/base/mixin
#= require_tree ./mixins/base
#= require_tree ./mixins

#= require ./models/base/model
#= require_tree ./models/base
#= require_tree ./models

#= require ./collections/base/collection
#= require_tree ./collections/base
#= require_tree ./collections

#= require      ./routers/base/router
#= require_tree ./routers/base
#= require_tree ./routers

#= require      ./views/base/view
#= require_tree ./views/base
#= require_tree ./views

@App =
  Cache: {}
  Mixins: {}
  Helpers: {}
  Models: {}
  Collections: {}
  Routers: {}
  Views: {}

_.extend App, Backbone.Events

$ ->
  Backbone.history.start pushState: true
```

In **app/assets/javscripts/application/mixins/base/mixin.coffee**:

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

In **app/assets/javscripts/application/models/base/model.coffee**:

```coffeescript
class App.Model extends Backbone.Model
_.extend App.Model, App.Mixins
```

In **app/assets/javscripts/application/collections/base/collection.coffee**:

```coffeescript
class App.Collection extends Backbone.Collection
_.extend App.Collection, App.Mixins
```

In **app/assets/javscripts/application/views/base/view.coffee**:

```coffeescript
class App.View extends Backbone.View
_.extend App.View, App.Mixins
```

In **app/assets/javascripts/application/routers/base/router.coffee**:

```coffeescript
class App.Router extends Backbone.Router
_.extend App.Router, App.Mixins
```

# Basics

Now that each of the Backbone JS structures (Models, Collections, Views and Routers) has been 'subclassed' (CoffeeScript uses the class keyword but really this is just a [wrapper for prototypal inheritance](http://coffeescript.org/#classes)) new files should inherit from one of the following:

- App.Model (instead of Backbone.Model)
- App.Collection (instead of Backbone.Collection)
- App.View (instead of Backbone.View)
- App.Router (instead of Backbone.Router)

For example, say that a basic task list is being created. It starts with modifying the main manifest file to include a new 'namespaces':

Modify **app/assets/javascripts/application/app.coffee**:

```coffeescript
...
@App =
  Cache: {}
  Mixins: {}
  Helpers: {}
  Models: {}
  Collections: {}
  Routers: {}
  Views:
    Tasks: {}
```

Then create a model **app/assets/javascripts/application/models/task.coffee**:

```coffeescript
class App.Models.Task extends App.Model
  defaults:
    notes: null
```

Then create a collection **app/assets/javascripts/application/collections/tasks.coffee**:

```coffeescript
class App.Collections.Tasks extends App.Collection
  url: '/tasks'
  model: App.Models.Task
```

Then define a view **app/assets/javascripts/application/views/tasks/index.coffee**:

```coffeescript
class App.Views.Tasks.Index extends App.View
  render: ->
    @$el.empty()
    for model in @collection.models
      @$el.append(model.get('notes'))
```

Add a router: **app/assets/javascripts/application/routers/tasks.coffee**:

```coffeescript
class App.Routers.Tasks extends App.Router

  routes:
    "tasks" : "index"

  index: ->
    collection = new App.Collections.Tasks [
      { id: 1, notes: "Dust" }
      { id: 2, notes: "Wash" }
    ]
    view = new App.Views.Tasks.Index(collection: collection)
    $('body').html(view.el)
    view.render()
```

Finally instantiate the router before starting the Backbone JS history from **app/assets/javascripts/application/app.coffee**:

```coffeescript
...
$ ->
   new App.Routers.Tasks()
   ...
```

The routes and models will also need to exist in the source (in this case with Rails) application:

```bash
rails generate model task notes:string
rails generate controller tasks
rake db:migrate
```

```ruby
# config/routes.rb
Rails.application.routes.draw do
  resources :tasks, only: :index
end
```

```ruby
# app/controllers/tasks_controller.rb
class TasksController < ApplicationController
  respond_to :html,:json

  # GET /tasks
  def index
    @tasks = Task.all
    respond_with(@tasks)
  end
end
```

```ruby
# app/views/tasks/index.html.haml
- provide :title, "Tasks"
```

If everything is setup properly and the '/tasks' endpoint is loaded the text 'Dust' and 'Wash' will appear. Some of the included gems (**handlebars_assets** and **hamlbars**) can be used to help simplify the rendering process. The previous example can be modified slightly to use a template:

Create **app/assets/javascripts/application/templates/tasks/index.hamlbars**:

```haml
.title Tasks
.tasks
  = hb('each .') do
    .task
      .notes= hb('notes')
```

Modify **app/assets/javascripts/application/views/tasks/index.coffee**:

```coffeescript
class App.Views.Tasks.Index extends App.View
  template: HandlebarsTemplates['tasks/index']

  parameters: ->
    @collection.map (model) ->
      notes: model.get('notes')

  render: ->
    @$el.html(@template(@parameters()))
```

# Syncing

The last step is to setup the application to grab data from the server. Right now the application doesn't support creating tasks (but this can be done from the Rails console):

```bash
rails console
```

```ruby
Task.create!(notes: "Folding")
Task.create!(notes: "Ironing")
```

Now it should be possible to verify that the server returns JSON:

```bash
curl tasks.dev/tasks.json

[{"id":1,"notes":"Folding","created_at":"2014-11-26T09:30:35.197Z","updated_at":"2014-11-26T09:30:35.197Z"},{"id":2,"notes":"Ironing","created_at":"2014-11-26T09:30:35.997Z","updated_at":"2014-11-26T09:30:35.997Z"}]
```

Modify **app/assets/javascripts/application/views/tasks/index.coffee**:

```coffeescript
class App.Views.Tasks.Index extends App.View
  ...

  initialize: ->
    @collection.on('sync', @render, @)
    super

  remove: ->
    @collection.off('sync', @render, @)
    super

  ...
```

Finally **app/assets/javascripts/application/routers/tasks.coffee**:

```coffeescript
class App.Routers.Tasks extends App.Router
  ...

  index: ->
    collection = new App.Collections.Tasks
    view = new App.Views.Tasks.Index(collection: collection)
    $('body').html(view.el)
    collection.fetch()
    view.render()

  ...
```

# Conclusion

That's it! Check some other posts for more Backbone tutorials.
