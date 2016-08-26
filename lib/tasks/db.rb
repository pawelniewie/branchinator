class BranchedDatabase
  def self.name(*args)
    new(*args).database_name
  end

  def initialize(prefix: application_name, separator: '_', env: Rails.env)
    @prefix = prefix
    @separator = separator
    @env = env
  end

  def current_branch
    `git branch | grep "*"`.chomp.split.last.parameterize
  end

  def database_name
    [@prefix, current_branch, @env].join(@separator)
  end

  def application_name
    Rails.application.class.name.split('::').first.downcase
  end
end

namespace :db do
  desc 'Create branch specific database and load db/schema.rb'
  task :branch => :environment do
    [:development, :test].each do |env|
      config = ActiveRecord::Base.configurations.values_at(env.to_s).first
      config['database'] = BranchedDatabase.name(env: env)

      ActiveRecord::Tasks::DatabaseTasks.create(config)
      ActiveRecord::Base.establish_connection(env)

      if env == :test
        ActiveRecord::Schema.verbose = false
      end
      ActiveRecord::Tasks::DatabaseTasks.load_schema
    end
  end

  desc 'Remove the branch specific database'
  task :unbranch => 'branch:remove'

  namespace :branch do
    task :remove => :drop

    desc 'Remove then Create the branch specific database'
    task :reset => [:remove, :branch]
  end
end