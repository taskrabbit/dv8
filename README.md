# Dv8

Dv8 gives you the ability to query against Rails.cache rather than your db. It works with all associations and queries.

## How

Singular lookups eg. `User.find()` fetch against `Rails.cache` and end up hitting your db as a backup. After hitting your db the attributes of the record are stored in the cache. Until the record changes, any query where record is part of the result will pull from the cache - even when the record is part of a result set.

Multiple result lookups are handled a little differently. A query always hits your db, but it only returns the primary keys. The primary keys are then checked in the cache. Any missing keys are queried in full from your db in a single query. The result sets are merged together with all ordering preserved.

For example. Given 3 users `A`,`B`, and `C` exist with primary keys `a`,`b`, and `c` but only user `A` is in the cache, the resulting queries would occur if all users were queried:

```ruby
User.all
# DB 
#  execute('select id from users')
#  => [a,b,c]
#
# CACHE
#  fetch('users-a')
#  => {...}
#  fetch('users-b')
#  => nil
#  fetch('users-c')
#  => nil
#
# DB
# execute('select * from users where id IN(b,c)')
#
# CACHE
#  write('users-b', {..})
#  write('users-c', {..})
#
# => [A,B,C] 
```

The next time all users are queried the following queries would take place (assuming the cache has not been invalidated):

```ruby
User.all
# DB 
#  execute('select id from users')
#  => [a,b,c]
#
# CACHE
#  fetch('users-a')
#  => {...}
#  fetch('users-b')
#  => {...}
#  fetch('users-c')
#  => {...}
#
# => [A,B,C]
```

## Installation

Add this line to your application's Gemfile:

    gem 'dv8'

And then execute:

    $ bundle

## Usage

To enable dv8 on a class just include the `Dv8::Base` module:

```ruby
class User < ActiveRecord::Base
  include Dv8::Base

  belongs_to  :club
  has_many    :badges
end
```

Now that dv8 is enabled you can query through the cache via the `#cfind()` method.

```ruby
User.cfind('john--3')
```

Associations are queried through the cache by invoking `cached_[association_name]`:

```ruby
user.cached_club
user.cached_badges
```

To query through the cache on any random query, just invoke the `cached` scope:

```ruby
User.cached.where(id: [1,2,3])
```

If you would like a class' `#find()` to always query through the cache you can include the `Dv8::AlwaysCache` module:

```ruby
class User < ActiveRecord::Base
  include Dv8::Base
  include Dv8::AlwaysCache
end
```

The AlwaysCache module is generally good to use for seed data.

## Integrations

Dv8 is blindly aware of slugging. If your model responds to `to_param`, `friendly_id`, `slug`, `cached_slug`, etc Dv8 will read and write any/all those keys. So a model with a slug column will have two entries into the cache:

```ruby
u = User.find('john')
u.dv8_keys
# => ['users-44', 'users-john']
```

Invalidation of the cache is automatically taken care of when you include `Dv8::Base` into your model. It uses the `after_update` and `after_touch` callbacks to invalidate the cache.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
