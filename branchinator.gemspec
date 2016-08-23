$:.push File.expand_path('../lib', __FILE__)
require 'branchinator/version'

Gem::Specification.new do |s|
  s.platform     = Gem::Platform::RUBY
  s.name         = 'branchinator'
  s.version      = Branchinator::VERSION
  s.summary      = 'Helps you manage database per branch'
  s.description  = 'Rails helper that simplifies database per branch development.'
  s.license      = 'MIT'

  s.author = 'Pawel Niewiadomski'
  s.email = '11110000b@gmail.com'
  s.homepage = 'https://pawelniewiadomski.com'

  s.required_ruby_version = '>= 2'

  s.files = Dir['README.md', 'MIT-LICENSE', 'lib/**/*']
  s.require_path = 'lib'

  s.add_development_dependency('rake')
end
