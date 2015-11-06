
# ConsciousConcern

[![Gem Version](https://badge.fury.io/rb/conscious_concern.svg)](http://badge.fury.io/rb/conscious_concern)
[![Dependency Status](https://gemnasium.com/janosch-x/conscious_concern.svg)](https://gemnasium.com/janosch-x/conscious_concern)
[![Code Climate](https://codeclimate.com/github/janosch-x/conscious_concern/badges/gpa.svg)](https://codeclimate.com/github/janosch-x/conscious_concern)

ConsciousConcern is a decorator for *ActiveSupport::Concern* that adds several metaprogramming features.

It is useful if you have concerns that are used by a large number of models, or concerns that regulary get added to new models. It consolidates the usage of such concerns by centralizing routing, application of related concerns, migrations, and more.

The examples below are just some possible use cases.

### Installation

Add it to your gemfile or run

    gem install conscious_concern

### Usage

If you are using Rails, add an initializer:

```ruby
# /config/initializers/conscious_concern.rb
ConsciousConcern.load_classes
```

This will let *ConsciousConcern* know about your models and controllers.

Now you can extend *ConsciousConcern* instead of *ActiveSupport::Concern* in your modules.

### Automatic controller integration

Let's assume you have a *Likable* concern for your models and a corresponding *Liking* concern for your controllers. Instead of including *Liking* manually in your controllers and keeping the controllers up to date when something new becomes *Likable* or something old is no longer *Likable*, just add a line to the model concern:

```ruby
module Likable
  extend ConsciousConcern
  let_controllers(include: Liking)
  # ...
end
```

Now, if you add *Likable* to, say, your *Comment* model, your *CommentsController* will automatically include *Liking*. You can also use *prepend:* or any other methods and arguments.

### Shared routes

Draw extra routes for all models that use a concern in one go.

```ruby
Likable.resources do
  member do
    post 'like'
  end
  collection do
    get 'most_liked'
  end
end

# => like_comment_path(comment)
# => like_event_path(event)
# => like_post_path(post)
# ...
# => most_liked_comments_path
# => most_liked_events_path
# => most_liked_posts_path
# ...
```

By default, this won't draw the standard RESTful routes, because you've probably done that already. 

However, you can pass the [usual restriction arguments](http://guides.rubyonrails.org/routing.html#restricting-the-routes-created) to draw some or all of them.

```ruby
Likable.resources(except: [:index]) # block is optional

# => comment_path
# => edit_comment_path
# => new_comment_path
# ...
```

### Shared migrations

Set up database fields for all models that use a concern in one go. This is probably only useful if your data model is pretty much set in stone.

```ruby
Likable.tables.each do |likable_table|
  change_table likable_table do |t|
    t.integer :like_count, null: false, default: 0
  end
end
```

### Special directory structures

*ConsciousConcern* needs to know about your models and controllers. By default, *::load_classes* assumes they'll be in the standard Rails paths.

If you have them in special paths, pass these paths to *::load_classes*. Subdirectories are searched automatically.

```ruby
# /config/initializers/conscious_concern.rb
ConsciousConcern.load_classes(my_special_model_dir,
                              my_other_model_dir,
                              my_controller_dir)
```

### Without Rails

If you are not using Rails, call *::load_classes* and pass the appropriate directories before using any of the features.

### Contributions

Feel free to send suggestions, point out issues, or submit pull requests.
