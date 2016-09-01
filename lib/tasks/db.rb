require 'branchinator/branched_database'
require 'branchinator/constants'

def create_database(env)
  branchinator = ActiveRecord::Base.configurations.values_at('branchinator').first || {}
  branchinator.deep_symbolize_keys!

  config = ActiveRecord::Base.configurations.values_at(env.to_s).first
  config['database'] = Branchinator::BranchedDatabase.name(branchinator.merge(env: env))

  ActiveRecord::Tasks::DatabaseTasks.create(config)
  ActiveRecord::Base.establish_connection(env)

  if env == :test
    ActiveRecord::Schema.verbose = false
  end

  if Rails.version.start_with? '4'
    ActiveRecord::Tasks::DatabaseTasks.load_schema_for(config)
  else
    ActiveRecord::Tasks::DatabaseTasks.load_schema(config)
  end

  ActiveRecord::Tasks::DatabaseTasks.load_seed

  config['database']
end

namespace :db do
  desc 'Create branch specific database and load db/schema.rb'
  task :branch => :environment do
    env_with_database = [:development, :test].map do |env|
      [env, create_database(env)]
    end

    File.write(Rails.root.join(Branchinator::FLAG_FILE), Hash[env_with_database].to_json)
  end

  desc 'Remove the branch specific database'
  task :unbranch => 'branch:remove'

  namespace :branch do
    task :remove => :drop do
      File.delete(Rails.root.join(Branchinator::FLAG_FILE))
    end

    desc 'Remove then Create the branch specific database'
    task :reset => [:remove, :branch]
  end
end
