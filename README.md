Branchinator
============

[![Gem Version](https://badge.fury.io/rb/branchinator.svg)](https://badge.fury.io/rb/branchinator)

Database per branch so you can easily switch between database models.

# How to use

`bin/rails db:branch`

Will create a new database and load it with seed. It will create `.branchinator` with db name for each env.

`bin/rails db:unbranch`

Will remove the database and `.branchinator` 

`bin/rails db:branch:reset`

Shortcut for branch remove + create.

# How to install

Put it into:

```ruby
group :development, :test do
  gem 'branchinator'
end
```

In you `database.yml` put:

```yaml
development:
  <<: *default
  database: <%= Branchinator.database %>
  
test:
  <<: *default
  database: <%= Branchinator.database %>
```

Update your `.gitingore` as well:

```echo .branchinator >> .gitignore```

