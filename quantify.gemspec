Gem::Specification.new do |s|
  s.name = "quantify"
  s.version = "1.0.0"
  s.date = "2011-03-03"
  s.authors = ["Andrew Berkeley"]
  s.email = "andrew.berkeley.is@googlemail.com"
  s.summary = "Quantify supports handling of physical quantities, unit conversions"
  s.homepage = "https://github.com/spatchcock/quantify"
  s.add_dependency('activesupport')
  s.files = [ "README", "COPYING" ]
  s.files += [ "lib/quantify.rb", "lib/quantify/quantify.rb", "lib/quantify/config.rb", "lib/quantify/core_extensions.rb",
               "lib/quantify/dimensions.rb", "lib/quantify/exception.rb", "lib/quantify/quantity.rb", "lib/quantify/inflections.rb" ]
  s.files += [ "lib/quantify/unit/base_unit.rb", "lib/quantify/unit/compound_unit.rb", "lib/quantify/unit/non_si_unit.rb",
               "lib/quantify/unit/si_unit.rb", "lib/quantify/unit/unit.rb", "lib/quantify/unit/compound_base_unit.rb" ]
  s.files += [ "lib/quantify/unit/prefix/base_prefix.rb", "lib/quantify/unit/prefix/non_si_prefix.rb",
               "lib/quantify/unit/prefix/si_prefix.rb", "lib/quantify/unit/prefix/prefix.rb" ]
  s.files += [ "spec/dimension_spec.rb", "spec/unit_spec.rb", "spec/quantity_spec.rb" ]
end
