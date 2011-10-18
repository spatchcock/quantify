# encoding: UTF-8
require 'quantify'
include Quantify

describe Unit do

  describe "compound unit symbols" do

    after :all do
      Unit.use_symbol_denominator_syntax!
      Unit.use_symbol_parentheses = false
    end

    it "should use denominator syntax by default" do
      unit = Unit.m*Unit.m*Unit.s*Unit.kg/(Unit.m*Unit.m*Unit.m*Unit.s)
      unit.symbol.should == "m² s kg/m³ s"
      Unit.metre_per_second.symbol.should eql "m/s"
    end
    
    it "should use indices only with bang! method" do
      Unit.use_symbol_indices_only!
      unit = Unit.m*Unit.m*Unit.s*Unit.kg/(Unit.m*Unit.m*Unit.m*Unit.s)
      unit.symbol.should == "m² s kg s^-1 m^-3"
      Unit.metre_per_second.symbol.should eql "m s^-1"
    end

    it "should use denominator syntax with bang! method" do
      Unit.use_symbol_denominator_syntax!
      unit = Unit.m*Unit.m*Unit.s*Unit.kg/(Unit.m*Unit.m*Unit.m*Unit.s)
      unit.symbol.should == "m² s kg/m³ s"
      Unit.metre_per_second.symbol.should eql "m/s"
    end

    it "should use indices only with setter method" do
      Unit.use_symbol_denominator_syntax = false
      unit = Unit.m*Unit.m*Unit.s*Unit.kg/(Unit.m*Unit.m*Unit.m*Unit.s)
      unit.symbol.should == "m² s kg s^-1 m^-3"
      Unit.metre_per_second.symbol.should eql "m s^-1"
    end

    it "should use denominator syntax with setter method" do
      Unit.use_symbol_denominator_syntax = true
      unit = Unit.m*Unit.m*Unit.s*Unit.kg/(Unit.m*Unit.m*Unit.m*Unit.s)
      unit.symbol.should == "m² s kg/m³ s"
      Unit.metre_per_second.symbol.should eql "m/s"
    end

    it "should use parentheses with setter method" do
      Unit.use_symbol_parentheses = true
      unit = Unit.m*Unit.m*Unit.s*Unit.kg/(Unit.m*Unit.m*Unit.m*Unit.s)
      unit.symbol.should == "(m² s kg)/(m³ s)"
      unit = Unit.m*Unit.m/(Unit.m*Unit.m*Unit.m*Unit.s)
      unit.symbol.should == "m²/(m³ s)"
      unit = Unit.m*Unit.m*Unit.s*Unit.kg/(Unit.m*Unit.m*Unit.m)
      unit.symbol.should == "(m² s kg)/m³"
    end

    it "should not use parentheses with setter method" do
      Unit.use_symbol_parentheses = false
      unit = Unit.m*Unit.m*Unit.s*Unit.kg/(Unit.m*Unit.m*Unit.m*Unit.s)
      unit.symbol.should == "m² s kg/m³ s"
      unit = Unit.m*Unit.m/(Unit.m*Unit.m*Unit.m*Unit.s)
      unit.symbol.should == "m²/m³ s"
      unit = Unit.m*Unit.m*Unit.s*Unit.kg/(Unit.m*Unit.m*Unit.m)
      unit.symbol.should == "m² s kg/m³"
    end

    it "should use parentheses with bang! method" do
      Unit.use_symbol_parentheses!
      unit = Unit.m*Unit.m*Unit.s*Unit.kg/(Unit.m*Unit.m*Unit.m*Unit.s)
      unit.symbol.should == "(m² s kg)/(m³ s)"
      unit = Unit.m*Unit.m/(Unit.m*Unit.m*Unit.m*Unit.s)
      unit.symbol.should == "m²/(m³ s)"
      unit = Unit.m*Unit.m*Unit.s*Unit.kg/(Unit.m*Unit.m*Unit.m)
      unit.symbol.should == "(m² s kg)/m³"
    end

  end

  describe "compound unit naming algorithms" do

    it "should return pluralised unit name" do
      Unit.m.pluralized_name.should == 'metres'
      Unit.ft.pluralized_name.should == 'feet'
      Unit.lux.pluralized_name.should == 'lux'
      Unit.kg.pluralized_name.should == 'kilograms'
      Unit.nautical_league.pluralized_name.should == 'nautical leagues'
      Unit.centimetre_of_water.pluralized_name.should == 'centimetres of water'
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

    it "squared unit should be called that" do
      (Unit.m**2).name.should == "square metre"
    end

    it "cubed unit should be called that" do
      (Unit.s**3).name.should == "cubic second"
    end

    it "raised unit should be called that" do
      (Unit.kg**4).name.should == "kilogram to the 4th power"
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
      unit.label.should == "MJ·m³/kg²"
    end

  end

  describe "specific compound unit operations" do

    it "should find equivalent unit for compound unit" do
      (Unit.kg*Unit.m*Unit.m/Unit.s/Unit.s).equivalent_known_unit.name.should == 'joule'
      (Unit.km*Unit.lb).equivalent_known_unit.should == nil
    end

    it "should return equivalent unit if appropriate" do
      (Unit.m*Unit.m).or_equivalent.name.should == 'square metre'
      (Unit.km*Unit.lb).or_equivalent.name.should == 'kilometre pound'
      (Unit.kg*Unit.m*Unit.m/Unit.s/Unit.s).or_equivalent.name.should == 'joule'
    end

    it "should consolidate across all base units" do
      unit = Unit.m*Unit.m*Unit.s*Unit.kg/(Unit.m*Unit.m*Unit.m*Unit.s)
      unit.symbol.should == "m² s kg/m³ s"
      unit.base_units.size.should == 5
      unit.consolidate_base_units!
      unit.symbol.should == "kg/m"
      unit.base_units.size.should == 2
    end

    it "should cancel base units with one argument which is a symbol" do
      unit = Unit.m*Unit.m*Unit.s*Unit.kg/(Unit.m*Unit.m*Unit.m*Unit.s)
      unit.symbol.should == "m² s kg/m³ s"
      unit.base_units.size.should == 5
      unit.cancel_base_units! :m
      unit.symbol.should == "s kg/m s"
      unit.base_units.size.should == 4
    end

    it "should cancel base units with multiple arguments including unit objects and strings" do
      unit = Unit.m*Unit.m*Unit.s*Unit.kg/(Unit.m*Unit.m*Unit.m*Unit.s)
      unit.symbol.should == "m² s kg/m³ s"
      unit.base_units.size.should == 5
      unit.cancel_base_units! Unit.m, 's'
      unit.symbol.should == "kg/m"
      unit.base_units.size.should == 2
    end

    it "should refuse to cancel by a compound unit" do
      unit = Unit.m*Unit.m*Unit.s*Unit.kg/(Unit.m*Unit.m*Unit.m*Unit.s)
      lambda{unit.cancel_base_units!(Unit.m**2)}.should raise_error
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
      compound_unit.symbol.should == "mi/h"
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
      compound_unit.symbol.should == "m²/h"
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

    it "should throw error if base unit is a compound unit" do
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


    it "should rationalize base units with automatically" do
      unit = Unit.yard*Unit.foot
      unit.rationalize_base_units!.label.should eql 'yd²'
      unit = Unit.metre*Unit.centimetre/Unit.inch
      unit.rationalize_base_units!.label.should eql 'm²/m'
      unit.consolidate_base_units!.label.should eql 'm'
    end

    it "should rationalize base units with specified unit" do
      unit = Unit.yard*Unit.foot
      unit.rationalize_numerator_and_denominator_units!(:yd).label.should eql 'yd²'
      unit = Unit.metre*Unit.centimetre/Unit.inch
      unit.rationalize_base_units!(:cm).label.should eql 'cm²/cm'
      unit.consolidate_base_units!.label.should eql 'cm'
    end

    it "should rationalize only numerator and denominator base units" do
      unit = Unit.yard*Unit.foot
      unit.rationalize_numerator_and_denominator_units!.label.should eql 'yd²'
      unit = Unit.metre*Unit.centimetre/Unit.inch
      unit.rationalize_numerator_and_denominator_units!.label.should eql 'm²/in'
      unit.consolidate_base_units!.label.should eql 'm²/in'
    end
    
  end

  describe "adding prefixes" do

    it "should have no valid prefixes with multiple base units" do
      (Unit.kg*Unit.m*Unit.m/Unit.s/Unit.s).valid_prefixes.should be_empty
    end

    it "should return SI prefixes with single SI unit" do
      prefixes = (Unit.kg**3).valid_prefixes
      prefixes.should_not be_empty
      prefixes.first.should be_a Unit::Prefix::SI
    end

    it "should return SI prefixes with single SI unit" do
      prefixes = (Unit.lb**3).valid_prefixes
      prefixes.should be_empty # no NonSI prefixes defined
    end

    it "should refuse to add prefix to multi-unit compound unit" do
      lambda{(Unit.kg*Unit.m*Unit.m/Unit.s/Unit.s).with_prefix(:giga)}.should raise_error
    end

    it "should prefix a single unit compound unit" do
      unit = (Unit.m**2).with_prefix(:kilo)
      unit.name.should eql "square kilometre"
      unit.factor.should == 1000000
    end


  end
end