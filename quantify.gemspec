Gem::Specification.new do |s|
  s.name = "quantify"
  s.version = "0.0.1"
  s.date = "2011-02-26"
  s.authors = ["Andrew Berkeley"]
  s.email = "andrew.berkeley.is@googlemail.com"
  s.summary = "Quantify supports handling of physical quantities, unit conversions"
  s.homepage = "https://github.com/spatchcock/quantify"
  s.files = [ "README", "COPYING" ]
  s.files += [ "lib/quantify.rb", "lib/quantify/base_unit.rb", "lib/quantify/compound_unit.rb", "lib/quantify/config.rb",
	       "lib/quantify/core_extensions.rb", "lib/quantify/dimensions.rb", "lib/quantify/exception.rb", "lib/quantify/non_si_unit.rb",
               "lib/quantify/prefix.rb", "lib/quantify/quantity.rb", "lib/quantify/si_unit.rb", "lib/quantify/unit.rb" ]
  s.files += [ "spec/dimension_spec.rb", "spec/unit_spec.rb", "spec/quantity_spec.rb" ]
end
