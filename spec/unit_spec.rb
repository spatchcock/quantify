require 'quantify'
include Quantify

describe Unit do

  it "symbols list should include" do
    list = Unit.symbols
    #list.should include 'η'
    list.should include 'g'
    list.should include 'kg'
    list.should include '°C'
    list.should include 'K'
    list.should include 'yd'
    list.should include 'ly'
    list.should include 'AU'
    list.should include 'lb'
    #list.should include 'eV'
  end

  it "symbols list should not include these" do
    Unit.symbols.should_not include 'zz'
  end

  it "si symbols list should include" do
    list = Unit.si_symbols
    #list.should include 'η'
    list.should include 'kg'
    list.should include 'K'
  end

  it "si symbols list should not include" do
    list = Unit.si_symbols
    list.should_not include '°C'
    list.should_not include 'yd'
    list.should_not include 'ly'
    list.should_not include 'AU'
    list.should_not include 'lb'
    list.should_not include 'eV'
  end

  it "non si symbols list should include" do
    list = Unit.non_si_symbols
    list.should include '°C'
    list.should include 'yd'
    list.should include 'ly'
    list.should include 'AU'
    list.should include 'lb'
    list.should include 'eV'
  end

  it "non si symbols list should not include" do
    list = Unit.non_si_symbols
    list.should_not include 'η'
    list.should_not include 'g'
    list.should_not include 'kg'
    list.should_not include 'K'
  end

  it "dynamic unit retrieval with name should be successful" do
    Unit.metre.name.should == 'metre'
    Unit.foot.symbol.should == 'ft'
  end

  it "dynamic unit retrieval with name and prefix should be successful" do
    unit = Unit.kilometre
    unit.name.should == 'kilometre'
    unit.factor.should == 1000
  end

  it "dynamic unit retrieval with name and invalid prefix should throw error" do
    lambda{Unit.megafoot}.should raise_error
  end

  it "dynamic unit retrieval with symbol should be successful" do
    Unit.m.name.should == 'metre'
    Unit.ft.symbol.should == 'ft'
    Unit.μm.factor.should == 0.000001
    Unit.°C.name.should == 'degree celsius'
  end

  it "dynamic unit retrieval with symbol and prefix should be successful" do
    Unit.km.name.should == 'kilometre'
    Unit.Gg.name.should == 'gigagram'
    Unit.cm.factor.should == 0.01
    Unit.TJ.name.should == 'terajoule'
    Unit.MMBTU.name.should == 'million british thermal unit (59 °f)'
  end

  it "dynamic unit retrieval with symbol and invalid prefix should raise error" do
    lambda{Unit.MMm}.should raise_error
    lambda{Unit.Gft}.should raise_error
    lambda{Unit.centimetre.with_prefix :kilo}.should raise_error
  end

  it "should load self into module variable with instance method" do
    unit = Unit::Base.new :physical_quantity => :mass, :name => 'megalump', :symbol => 'Mlp'
    unit.load
    Unit.symbols.should include 'Mlp'
    Unit.names.should include 'megalump'
  end

  it "should create unit" do
    unit = Unit::NonSI.new :name => 'a name', :physical_quantity => :energy, :factor => 10
    unit.class.should == Unit::NonSI
  end

  it "should throw error when creating unit with no name" do
    lambda{unit = Unit::NonSI.new :physical_quantity => :energy, :factor => 10}.should raise_error
  end

  it "should throw error when creating unit with no physical quantity" do
    lambda{unit = Unit::NonSI.new :name => 'energy', :factor => 10}.should raise_error
  end

  it "should load unit into module array with class method" do
    unit = Unit::NonSI.load :name => 'a name', :physical_quantity => :energy, :factor => 10
    Unit.non_si_names.should include 'a name'
  end

  it "should return a scaling of zero if SI" do
    unit = Unit.cm
    unit.scaling.should == 0.0
  end

  it "should return a scaling of zero if NonSI and no appropriate value" do
    unit = Unit.ft
    unit.scaling.should == 0.0
  end

  it "should return a scaling value if appropriate" do
    unit = Unit.degree_farenheit
    unit.scaling.should == 459.67
  end

  it "should return the physical quantity" do
    unit = Unit.metre
    unit.measures.should == 'length'
  end

  it "should return the physical quantity" do
    unit = Unit.joule
    unit.measures.should == 'energy'
  end

  it "should return the physical quantity" do
    unit = Unit.BTU
    unit.measures.should == 'energy'
  end

  it "should recognise joule as SI" do
    unit = Unit.J
    unit.is_si_unit?.should == true
  end

  it "should recognise newton as SI" do
    unit = Unit.N
    unit.is_si_unit?.should == true
  end

  it "should recognise kilometre as SI" do
    unit = Unit.kilometre
    unit.is_si_unit?.should == true
  end

  it "should recognise foot as non SI" do
    unit = Unit.ft
    unit.is_si_unit?.should_not == true
  end

  #it "should recognise dram as non SI" do
  #  unit = Unit.dram
  #  unit.is_si_unit?.should_not == true
  #end

  it "should recognise BTU as non SI" do
    unit = Unit.british_thermal_unit
    unit.is_si_unit?.should_not == true
  end

  it "should recognise similar units" do
    unit_1 = Unit.yard
    unit_2 = Unit.yard
    unit_1.is_same_as?(unit_2).should == true
  end

  it "should recognise non-similar units" do
    unit_1 = Unit.yard
    unit_2 = Unit.foot
    unit_1.is_same_as?(unit_2).should_not == true
  end

  it "should recognise non-similar units" do
    unit_1 = Unit.yard
    unit_2 = Unit.kelvin
    (unit_1 == unit_2).should_not == true
  end

  it "should recognise alternative units" do
    unit_1 = Unit.yard
    unit_2 = Unit.foot
    unit_1.is_alternative_for?(unit_2).should == true
  end

  it "should recognise non-alternative units" do
    unit_1 = Unit.yard
    unit_2 = Unit.kelvin
    unit_1.is_alternative_for?(unit_2).should_not == true
  end

  it "should list alternative unit objects" do
    unit = Unit.kg
    unit.alternatives.class.should == Array
    unit.alternatives[0].is_a?(Unit::SI).should == true
    unit.alternatives[0].symbol.should == 'g'
  end

  it "should list alternative unit symbols" do
    unit = Unit.kg
    unit.alternatives(:symbol).class.should == Array
    unit.alternatives(:symbol)[0].is_a?(String).should == true
    unit.alternatives(:symbol)[0].should == 'g'
  end

  it "should list alternative unit names" do
    unit = Unit.kg
    unit.alternatives(:name).class.should == Array
    unit.alternatives(:name)[0].is_a?(String).should == true
    unit.alternatives(:name)[0].should == 'gram'
  end

  it "should multiply units" do
    kilometre = Unit.km
    hour = Unit.h
    new = kilometre / hour
    new.measures.should == 'velocity'
  end

  it "should divide units" do
    kilowatt = Unit.kW
    hour = Unit.h
    new = kilowatt * hour
    new.measures.should == 'energy'
  end

  it "should multiply units" do
    length_1 = Unit.m
    length_2 = Unit.m
    new = length_1 * length_2
    new.measures.should == 'area'
  end

  it "should divide units" do
    energy = Unit.J
    length = Unit.m
    new = energy / length
    new.measures.should == 'force'
  end

  it "should create compound" do
    unit = (Unit.kg / Unit.kWh)
    unit.name.should == 'kilogram per kilowatt hour'
    unit.measures.should_not == 'energy'
  end

  it "should recognise known units from compound units based on dimensions and factor" do
    unit = Unit.kg*Unit.m*Unit.m/Unit.s/Unit.s
    unit.equivalent_known_unit.name.should == 'joule'
  end

  it "should recognise a compound unit" do
    (Unit.m*Unit.t).is_compound_unit?.should == true
    Unit.m.is_compound_unit?.should == false
  end

  it "should raise unit to power" do
    (Unit.m**3).measures.should == 'volume'
  end

  it "coerce method should handle reciprocal syntax" do
    (1/Unit.s).name.should == 'per second'
  end

  it "should throw error when trying to add prefix to prefixed-unit" do
    lambda{Unit.kilometre.with_prefix :giga}.should raise_error
  end

  it "should add prefix with explcit method" do
    Unit.metre.with_prefix(:c).name.should == 'centimetre'
  end

  it "should return pluralised unit name" do
    Unit.m.pluralized_name.should == 'metres'
    Unit.ft.pluralized_name.should == 'feet'
    Unit.lux.pluralized_name.should == 'lux'
    Unit.kg.pluralized_name.should == 'kilograms'
    #Unit.nautical_league.pluralized_name.should == 'nautical leagues'
    #Unit.centimetre_of_water.pluralized_name.should == 'centimetres of water'
    (Unit.t*Unit.km).pluralized_name.should == 'tonne kilometres'
    (Unit.t*Unit.km/Unit.year).pluralized_name.should == 'tonne kilometres per year'
    (Unit.kg*Unit.m*Unit.m/Unit.s/Unit.s).or_equivalent.pluralized_name.should == 'joules'
  end

  it "should create unit with dynamic method and pluralized name" do
    Unit.feet.symbol.should == 'ft'
    Unit.gigagrams.name.should == 'gigagram'
    (Unit.kilograms/(Unit.tonne*Unit.km)).pluralized_name.should == 'kilograms per tonne kilometre'
    (Unit.kilograms/(Unit.megagrams*Unit.km)).pluralized_name.should == 'kilograms per megagram kilometre'
  end
  
  it "should recognise compound units based entirely on SI units" do
    unit = Unit.kg*Unit.m
    unit.is_si_unit?.should == true
  end
  
  it "should recognise compound units based entirely on SI units" do
    unit = Unit.lb*Unit.m*Unit.m/Unit.s/Unit.s
    unit.is_si_unit?.should == false
  end

  it "should recognise compound units based entirely on SI units" do
    unit = Unit.kg*Unit.m*Unit.m/Unit.s/Unit.s
    unit.is_si_unit?.should == true
  end

  it "should recognise compound units based entirely on SI units" do
    unit = (Unit.kilograms/(Unit.megagram*Unit.km))
    unit.is_si_unit?.should == true
  end

  it "should recognise compound units based entirely on SI units" do
    unit = (Unit.kilograms/(Unit.tonne*Unit.km))
    unit.is_si_unit?.should == false
  end

  it "megagram and tonne should be similar" do
    tonne = Unit.t
    tonne.symbol.should == 't'
    tonne.factor.should == 1000.0
    megagram = Unit.Mg
    megagram.symbol.should == 'Mg'
    megagram.factor.should == 1000.0
    megagram.should == tonne
  end

  it "squared unit should be called that" do
    (Unit.m**2).name.should == "square metre"
  end

  it "cubed unit should be called that" do
    (Unit.s**3).name.should == "cubic second"
  end

  it "raised unit should be called that" do
    (Unit.kg**4).name.should == "kilogram to the 4th power"
  end

  it "should raise to power -1" do
    (Unit.s**-1).dimensions.time.should == -1
  end

  it "should raise to power -2" do
    unit = Unit.m**-2
    unit.name.should == 'per square metre'
  end

  it "should parse string into correct single unit" do
    Unit.parse("kg").name.should == "kilogram"
  end

  it "should parse string into correct single unit" do
    Unit.parse("T").name.should == "tesla"
  end

  it "should parse string into correct single unit" do
    Unit.parse("Tm").name.should == "terametre"
  end

  it "should parse string into correct compound unit" do
    Unit.parse("kg kWh^-1").name.should == "kilogram per kilowatt hour"
  end

  it "should parse string into correct compound unit" do
    Unit.parse("m^2").name.should == "square metre"
  end

  it "should parse string into correct compound unit" do
    Unit.parse("m^-3").name.should == "per cubic metre"
  end

  it "should return correct unit ratio quantity with symbols" do
    Unit.ratio(:lb,:kg).to_s(:name).should == "2.20462262184878 pounds per kilogram"
  end

  it "should return correct unit ratio quantity with symbols and rounding" do
    Unit.ratio(:lb,:kg).round(3).to_s(:name).should == "2.205 pounds per kilogram"
  end

 it "should return correct unit ratio quantity with strings" do
    Unit.ratio('K','degree farenheit').round(5).to_s(:name).should == "0.55556 kelvins per degree farenheit"
  end

  it "should return correct unit ratio quantity with unit instance" do
    Unit.ratio(Unit.square_metre,'hectare').round.to_s(:name).should == "10000 square metres per hectare"
  end

  it "should recognise a base unit" do
    Unit.m.is_base_unit?.should == true
    Unit.K.is_base_unit?.should == true
    Unit.degree_celsius.is_base_unit?.should == true
    Unit.ft.is_base_unit?.should == true
    Unit.cd.is_base_unit?.should == true
    (Unit.square_metre/Unit.m).is_base_unit?.should == true
    (Unit.km/Unit.h).is_base_unit?.should == false
    Unit.J.is_base_unit?.should == false
    Unit.N.is_base_unit?.should == false
    Unit.W.is_base_unit?.should == false
  end

  it "should recognise a derived unit" do
    Unit.m.is_derived_unit?.should == false
    Unit.K.is_derived_unit?.should == false
    Unit.degree_celsius.is_derived_unit?.should == false
    Unit.ft.is_derived_unit?.should == false
    Unit.cd.is_derived_unit?.should == false
    (Unit.cubic_metre/Unit.square_metre).is_derived_unit?.should == false
    Unit.J.is_derived_unit?.should == true
    Unit.N.is_derived_unit?.should == true
    Unit.W.is_derived_unit?.should == true
    Unit.parse("m^3").is_derived_unit?.should == true
    (Unit.m/Unit.s).is_derived_unit?.should == true
  end

  it "should recognise a prefixed unit" do
    Unit.m.is_prefixed_unit?.should == false
    Unit.K.is_prefixed_unit?.should == false
    Unit.degree_celsius.is_prefixed_unit?.should == false
    Unit.ft.is_prefixed_unit?.should == false
    Unit.cd.is_prefixed_unit?.should == false
    (Unit.cubic_metre/Unit.square_metre).is_derived_unit?.should == false
    Unit.TJ.is_prefixed_unit?.should == true
    Unit.GN.is_prefixed_unit?.should == true
    Unit.kW.is_prefixed_unit?.should == true
    Unit.parse("Gcd").is_prefixed_unit?.should == true
    Unit.parse("picosecond").is_prefixed_unit?.should == true
  end

  it "should recognise a benchmark unit" do
    Unit.m.is_benchmark_unit?.should == true
    Unit.K.is_benchmark_unit?.should == true
    Unit.degree_celsius.is_benchmark_unit?.should == true
    Unit.ft.is_benchmark_unit?.should == false
    Unit.cd.is_benchmark_unit?.should == true
    (Unit.cubic_metre/Unit.square_metre).is_benchmark_unit?.should == true
    Unit.TJ.is_benchmark_unit?.should == false
    Unit.N.is_benchmark_unit?.should == true
    Unit.kW.is_benchmark_unit?.should == false
    Unit.parse("kg").is_benchmark_unit?.should == true
    Unit.parse("picosecond").is_benchmark_unit?.should == false
  end

  it "should return correct SI unit" do
    Unit.ft.si_unit.name.should == 'metre'
    Unit.lb.si_unit.name.should == 'kilogram'
    Unit.BTU.si_unit.name.should == 'joule'
    (Unit.ft**2).si_unit.name.should == 'square metre'
    Unit.pounds_force_per_square_inch.si_unit.name.should == 'pascal'
  end

  it "should create new instance with block initialize" do
    unit = Unit::Base.new do |unit|
      unit.name = 'megapanda'
      unit.symbol = 'Mpd'
      unit.dimensions = Dimensions.dimensionless
    end
    unit.class.should == Quantify::Unit::Base
    unit.symbol.should == 'Mpd'
  end

  it "should raise with block initialize and no name" do
    lambda{unit = Unit::Base.new do |unit|
      unit.symbol = 'Mpd'
      unit.dimensions = Dimensions.dimensionless
    end}.should raise_error
  end

  it "should raise with block initialize and no dimensions" do
    lambda{unit = Unit::Base.new do |unit|
      unit.symbol = 'Mpd'
      unit.name = 'megapanda'
    end}.should raise_error
  end

  it "should modify unit attributes with block and #operate" do
    unit = (Unit.kg/Unit.kWh).operate do |u|
      u.name = 'electricity emissions factor'
    end
    unit.class.should == Quantify::Unit::Compound
    unit.name = 'electricity emissions factor'
  end

  it "should raise error with block and #operate which removes name" do
    lambda{(Unit.kg/Unit.kWh).operate do |u|
      u.name = ""
    end}.should raise_error
  end

  it "should load new unit with block and #load" do
    (Unit.kg/Unit.kWh).load do |u|
      u.name = 'electricity emissions factor'
      u.label = 'elec_fac'
    end
    unit = Unit.electricity_emissions_factor
    unit.class.should == Quantify::Unit::Compound
    unit.name = 'electricity emissions factor'
  end

  it "should raise error with block and #load which removes name" do
    lambda{(Unit.kg/Unit.kWh).load do |u|
      u.name = ""
    end}.should raise_error
  end

  it "should recognize already loaded units" do
    Unit.m.loaded?.should == true
    Unit.ft.loaded?.should == true
    Unit.kilometre.loaded?.should == true
    (Unit.m/Unit.K).loaded?.should == false
    Unit.m.with_prefix(:pico).loaded?.should == false
    Unit.J.loaded?.should == true
    Unit.psi.loaded?.should == true
  end

  it "should allow dimensions to be specified with :physical_quantity key" do
    unit = Unit::Base.new :physical_quantity => :mass, :name => 'gigapile'
    unit.class.should == Quantify::Unit::Base
  end

  it "should allow dimensions to be specified with :dimensions key" do
    unit = Unit::Base.new :dimensions => :mass, :name => 'gigapile'
    unit.class.should == Quantify::Unit::Base
  end

  it "should derive correct label for compound unit" do
    unit = (Unit.kg/(Unit.t*Unit.km))
    unit.label.should == "kg/t·km"
  end

  it "should derive correct label for compound unit" do
    unit = 1/Unit.m
    unit.label.should == "m^-1"
  end

  it "should derive correct label for compound unit" do
    unit = Unit.MJ*(Unit.m**3)/(Unit.kg**2)
    unit.label.should == "MJ·m^3/kg^2"
  end

  it "should find equivalent unit for compound unit" do
    (Unit.m*Unit.m).equivalent_known_unit.name.should == 'square metre'
    (Unit.km*Unit.lb).equivalent_known_unit.should == nil
  end

  it "should return equivalent unit if appropriate" do
    (Unit.m*Unit.m).or_equivalent.name.should == 'square metre'
    (Unit.km*Unit.lb).or_equivalent.name.should == 'kilometre pound'
    (Unit.kg*Unit.m*Unit.m/Unit.s/Unit.s).or_equivalent.name.should == 'joule'
  end

  it "should consolidate across all base units" do
    unit = Unit.m*Unit.m*Unit.s*Unit.kg/(Unit.m*Unit.m*Unit.m*Unit.s)
    unit.symbol.should == "m^2 s kg s^-1 m^-3"
    unit.base_units.size.should == 5
    unit.consolidate_base_units!(:full)
    unit.symbol.should == "kg m^-1"
    unit.base_units.size.should == 2
  end

  it "should cancel base units with one argument which is a symbol" do
    unit = Unit.m*Unit.m*Unit.s*Unit.kg/(Unit.m*Unit.m*Unit.m*Unit.s)
    unit.symbol.should == "m^2 s kg s^-1 m^-3"
    unit.base_units.size.should == 5
    unit.cancel_base_units! :m
    unit.symbol.should == "s kg m^-1 s^-1"
    unit.base_units.size.should == 4
  end

  it "should cancel base units with multiple arguments including unit objects and strings" do
    unit = Unit.m*Unit.m*Unit.s*Unit.kg/(Unit.m*Unit.m*Unit.m*Unit.s)
    unit.symbol.should == "m^2 s kg s^-1 m^-3"
    unit.base_units.size.should == 5
    unit.cancel_base_units! Unit.m, 's'
    unit.symbol.should == "kg m^-1"
    unit.base_units.size.should == 2
  end

  it "should refuse to cancel by a compound unit" do
    unit = Unit.m*Unit.m*Unit.s*Unit.kg/(Unit.m*Unit.m*Unit.m*Unit.s)
    lambda{unit.cancel_base_units!(Unit.m**2)}.should raise_error
  end

  it "trying to add invalid prefix should raise error" do
    lambda{Unit.ft.with_prefix(:kilo)}.should raise_error
  end

  it "should initialize compound unit with one CompoundBaseUnit" do
    base = Unit::CompoundBaseUnit.new Unit.h, -1
    compound_unit = Unit::Compound.new base
    compound_unit.symbol.should == "h^-1"
  end

  it "should initialize compound unit with multiple CompoundBaseUnits" do
    base1 = Unit::CompoundBaseUnit.new Unit.h, -1
    base2 = Unit::CompoundBaseUnit.new Unit.mi
    compound_unit = Unit::Compound.new base1, base2
    compound_unit.symbol.should == "mi h^-1"
  end

  it "should initialize compound unit with multiple individual units" do
    base1 = Unit.kW
    base2 = Unit.h
    compound_unit = Unit::Compound.new base1, base2
    compound_unit.symbol.should == "kW h"
  end

  it "should initialize compound unit with array splat of multiple individual units" do
    base1 = Unit.kW
    base2 = Unit.h
    array = [base1,base2]
    compound_unit = Unit::Compound.new *array
    compound_unit.symbol.should == "kW h"
  end

  it "should initialize compound unit with one sub-array" do
    base1 = [Unit.h, -1]
    compound_unit = Unit::Compound.new base1
    compound_unit.symbol.should == "h^-1"
  end

  it "should initialize compound unit with multiple sub-arrays" do
    base1 = [Unit.h, -1]
    base2 = [Unit.m, 2]
    compound_unit = Unit::Compound.new base1, base2
    compound_unit.symbol.should == "m^2 h^-1"
  end

  it "should initialize compound unit with variable arguments" do
    base1 = Unit.kg
    base2 = Unit::CompoundBaseUnit.new Unit.m, 2
    base3 = [Unit.s, -2]
    compound_unit = Unit::Compound.new base1, base2, base3
    compound_unit.measures.should == "energy"
  end

  it "should initialize compound unit with variable arguments in splat array" do
    base1 = Unit.kg
    base2 = Unit::CompoundBaseUnit.new Unit.m, 2
    base3 = [Unit.s, -2]
    array = [base1,base2,base3]
    compound_unit = Unit::Compound.new *array
    compound_unit.measures.should == "energy"
  end

  it "should throw error is base unit is a compound unit" do
    base1 = Unit.kg*Unit.m
    base2 = Unit::CompoundBaseUnit.new Unit.m, 2
    base3 = [Unit.s, -2]
    array = [base1,base2,base3]
    lambda{compound_unit = Unit::Compound.new *array}.should raise_error
  end

  it "should throw error is base unit is a compound unit" do
    base1 = Unit.kg
    base2 = Unit::CompoundBaseUnit.new Unit.m, 2
    base3 = [Unit.kg*Unit.m, -2]
    array = [base1,base2,base3]
    lambda{compound_unit = Unit::Compound.new *array}.should raise_error
  end

  it "should throw error is base unit array too big" do
    base1 = Unit.kg
    base2 = Unit::CompoundBaseUnit.new Unit.m, 2
    base3 = [Unit.kg, -2, "something else"]
    array = [base1,base2,base3]
    lambda{compound_unit = Unit::Compound.new *array}.should raise_error
  end

  it "should not allow comound unit to be used to initialize CompoundBaseUnit" do
    lambda{Unit::CompoundBaseUnit.new((Unit.m*Unit.m), 2)}.should raise_error
  end

  it "should parse per unit correctly" do
    unit = Unit.parse "s^-1"
    unit.name.should == 'per second'
  end

  it "should raise error when parsing on unknown units" do
    lambda{unit = Unit.parse "kg b^2"}.should raise_error
  end

  it "compound unit should be recognsed as Unit::Base and Compound" do
    unit = Unit.m*Unit.kg*Unit.s
    unit.is_a?(Unit::Base).should be_true
    unit.is_a?(Unit::Compound).should be_true
    unit.is_a?(Unit::SI).should_not be_true
    unit.is_a?(Unit::NonSI).should_not be_true
  end
end

