# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'
require 'rspec'
require 'rspec/core/rake_task'

task :default => [:spec]

desc "Run specs"
RSpec::Core::RakeTask.new do |t|
  # Put spec opts in a file named .rspec in root
end

require 'jeweler'

Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "quantify"
  gem.homepage = "https://github.com/spatchcock/quantify"
  gem.license = "MIT"
  gem.summary = %Q{Support for handling physical quantities, unit conversions, etc}
  gem.description = %Q{A gem to support physical quantities and unit conversions}
  gem.email = "andrew.berkeley.is@googlemail.com"
  gem.authors = ["Andrew Berkeley"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rdoc/task'
RDoc::Task.new do |rd|
  rd.title = "Quantify"
  rd.rdoc_dir = 'doc'
  rd.main = "README"
  rd.rdoc_files.include("README", "lib/**/*.rb")
end