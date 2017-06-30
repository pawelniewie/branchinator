Branchinator
============

[![Gem Version](https://badge.fury.io/rb/branchinator.svg)](https://badge.fury.io/rb/branchinator)

Database per branch so you can easily switch between database models.

Works with Rails 4.x and 5.x

# How to use

`bundle exec rake db:branch`

Will create a new database and load it with seed. It will create `.branchinator` with db name for each env.

`bundle exec rake db:unbranch`

Will remove the database and `.branchinator` 

`bundle exec rake db:branch:reset`

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

# Additional configuration

By default database name is taken from application name and looks something like:

`awesomeproject_branch_environment`

If you want you can change the first part and the separator.

In your `database.yml` put:

```yaml
branchinator:
  prefix: awesome-project
  separator: _
```
