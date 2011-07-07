require 'rake'

Gem::Specification.new do |s|
  s.name = "quantify"
  s.version = "1.1.0"
  s.date = "2011-07-06"
  s.authors = ["Andrew Berkeley"]
  s.email = "andrew.berkeley.is@googlemail.com"
  s.summary = "Quantify supports handling of physical quantities, unit conversions"
  s.homepage = "https://github.com/spatchcock/quantify"
  s.add_dependency('activesupport')
  s.files = [ "README", "COPYING" ]
  s.files += ::FileList.new('lib/**/*.rb')
  s.files += ::FileList.new('spec/*.rb')
end
