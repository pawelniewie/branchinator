class BranchedDatabase
  def self.name(*args)
    new.name(*args)
  end

  def current_branch
    `git branch | grep "*"`.chomp.split.last.parameterize
  end

  def existing_databases
    if ENV['DB_PASSWORD'].present?
      password = "-p#{ENV['DB_PASSWORD']}"
    end
    `mysql -u #{ENV['DB_USER']} #{password} -h #{ENV['DB_HOST']} -e \"show databases\"`.chomp.split
  end

  def name(prefix: application_name, separator: '_')
    branch_database = [prefix, current_branch].join(separator)
    if existing_databases.include?(branch_database)
      branch_database
    else
      [prefix, Rails.env].join(separator)
    end
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

      if env == :development
        bdb = BranchedDatabase.new
        config['database'] = [bdb.application_name, bdb.current_branch].join('_')
      end

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