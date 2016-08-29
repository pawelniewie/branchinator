module Branchinator
  class BranchedDatabase
    def self.name(*args)
      new(*args).branch_database
    end

    def initialize(prefix: application_name, separator: '_', env: Rails.env)
      @prefix = prefix
      @separator = separator
      @env = env
    end

    def current_branch
      `git branch | grep "*"`.chomp.split.last.parameterize
    end

    def branch_database
      [@prefix, current_branch, @env].join(@separator)
    end

    def default_database
      [@prefix, @env].join(@separator)
    end

    def application_name
      Rails.application.class.name.split('::').first.downcase
    end
  end
end

