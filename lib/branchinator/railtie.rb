module Branchinator
  class Railtie < Rails::Railtie
    rake_tasks do
      require 'tasks/db'
    end
  end
end