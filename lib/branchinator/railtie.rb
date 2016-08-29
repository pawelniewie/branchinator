require 'branchinator/branched_database'
require 'branchinator/constants'

module Branchinator
  class Railtie < Rails::Railtie
    rake_tasks do
      require 'tasks/db'
    end
  end
end