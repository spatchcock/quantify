# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "quantify"
  s.version = "3.1.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Andrew Berkeley"]
  s.date = "2012-10-30"
  s.description = "A gem to support physical quantities and unit conversions"
  s.email = "andrew.berkeley.is@googlemail.com"
  s.extra_rdoc_files = [
    "README.md"
  ]
  s.files = [
    "COPYING",
    "Gemfile",
    "README.md",
    "Rakefile",
    "VERSION",
    "lib/quantify.rb",
    "lib/quantify/config.rb",
    "lib/quantify/core_extensions/numeric.rb",
    "lib/quantify/core_extensions/range.rb",
    "lib/quantify/core_extensions/string.rb",
    "lib/quantify/core_extensions/symbol.rb",
    "lib/quantify/dimensions.rb",
    "lib/quantify/exception.rb",
    "lib/quantify/inflections.rb",
    "lib/quantify/quantify.rb",
    "lib/quantify/quantity.rb",
    "lib/quantify/unit/base_unit.rb",
    "lib/quantify/unit/compound_base_unit.rb",
    "lib/quantify/unit/compound_base_unit_list.rb",
    "lib/quantify/unit/compound_unit.rb",
    "lib/quantify/unit/non_si_unit.rb",
    "lib/quantify/unit/prefix/base_prefix.rb",
    "lib/quantify/unit/prefix/non_si_prefix.rb",
    "lib/quantify/unit/prefix/prefix.rb",
    "lib/quantify/unit/prefix/si_prefix.rb",
    "lib/quantify/unit/si_unit.rb",
    "lib/quantify/unit/unit.rb",
    "quantify.gemspec",
    "spec/compound_unit_spec.rb",
    "spec/dimension_spec.rb",
    "spec/quantity_spec.rb",
    "spec/string_spec.rb",
    "spec/unit_spec.rb"
  ]
  s.homepage = "https://github.com/spatchcock/quantify"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "Support for handling physical quantities, unit conversions, etc"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, ["~> 3.0"])
      s.add_runtime_dependency(%q<i18n>, [">= 0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.6.4"])
      s.add_development_dependency(%q<rspec>, ["~> 2.6.0"])
      s.add_development_dependency(%q<rcov>, [">= 0"])
      s.add_development_dependency(%q<rdoc>, [">= 0"])
    else
      s.add_dependency(%q<activesupport>, ["~> 3.0"])
      s.add_dependency(%q<i18n>, [">= 0"])
      s.add_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.6.4"])
      s.add_dependency(%q<rspec>, ["~> 2.6.0"])
      s.add_dependency(%q<rcov>, [">= 0"])
      s.add_dependency(%q<rdoc>, [">= 0"])
    end
  else
    s.add_dependency(%q<activesupport>, ["~> 3.0"])
    s.add_dependency(%q<i18n>, [">= 0"])
    s.add_dependency(%q<bundler>, ["~> 1.0.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.6.4"])
    s.add_dependency(%q<rspec>, ["~> 2.6.0"])
    s.add_dependency(%q<rcov>, [">= 0"])
    s.add_dependency(%q<rdoc>, [">= 0"])
  end
end

