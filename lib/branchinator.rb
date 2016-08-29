require 'branchinator/railtie' if defined?(Rails)
require 'branchinator/version'

module Branchinator

  def self.database()
    dot_file = Rails.root.join(Branchinator::FLAG_FILE)
    if dot_file.exist?
      JSON.load(dot_file)[Rails.env] || self.default_database
    else
      self.default_database
    end
  end

  def self.default_database()
    BranchedDatabase.new.default_database
  end

end