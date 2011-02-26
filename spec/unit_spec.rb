require 'quantify'
include Quantify

describe Unit do

  it "symbols list should include" do
    list = Unit.symbols
    list.should include :η
    list.should include :g
    list.should include :kg
    list.should include :"°C"
    list.should include :K
    list.should include :yd
    list.should include :ly
    list.should include :AU
    list.should include :lb
    list.should include :eV
  end

  it "symbols list should not include these" do
    Unit.symbols.should_not include :zz
  end

  it "si symbols list should include" do
    list = Unit.si_symbols
    list.should include :η
    list.should include :g
    list.should include :kg
    list.should include :K
  end

  it "si symbols list should not include" do
    list = Unit.si_symbols
    list.should_not include :"°C"
    list.should_not include :yd
    list.should_not include :ly
    list.should_not include :AU
    list.should_not include :lb
    list.should_not include :eV
  end

  it "non si symbols list should not include" do
    list = Unit.non_si_symbols
    list.should include :"°C"
    list.should include :yd
    list.should include :ly
    list.should include :AU
    list.should include :lb
    list.should include :eV
  end

  it "non si symbols list should not include" do
    list = Unit.non_si_symbols
    list.should_not include :η
    list.should_not include :g
    list.should_not include :kg
    list.should_not include :K
  end

  it "dynamic unit retrieval with name should be successful" do
    Unit.metre.name.should == :metre
    Unit.foot.symbol.should == :ft
  end

  it "dynamic unit retrieval with name and prefix should be successful" do
    unit = Unit.kilometre
    unit.name.should == :kilometre
    unit.factor.should == 1000
  end

  it "dynamic unit retrieval with name and invalid prefix should throw error" do
    lambda{Unit.megafoot}.should raise_error
  end

  it "dynamic unit retrieval with symbol should be successful" do
    Unit.m.name.should == :metre
    Unit.ft.symbol.should == :ft
    Unit.μm.factor.should == 0.000001
    Unit.°C.name.should == :degree_celsius
  end

  it "dynamic unit retrieval with symbol and prefix should be successful" do
    Unit.km.name.should == :kilometre
    Unit.Gg.name.should == :gigagram
    Unit.cm.factor.should == 0.01
    Unit.TJ.name.should == :terajoule
    Unit.MMBTU.name.should == :million_british_thermal_unit
  end

  it "dynamic unit retrieval with symbol and invalid prefix should raise error" do
    lambda{Unit.MMm}.should raise_error
    lambda{Unit.Gft}.should raise_error
  end

  it "should load self into module variable with instance method" do
    unit = Unit.Gg
    unit.load
    Unit.symbols.should include :Gg
    Unit.names.should include :gigagram
    Unit.si_names.should include :gigagram
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
    Unit.non_si_names.should include :a_name
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
    unit.measures.should == :length
  end

  it "should return the physical quantity" do
    unit = Unit.joule
    unit.measures.should == :energy
  end

  it "should return the physical quantity" do
    unit = Unit.BTU
    unit.measures.should == :energy
  end

  it "should recognise joule as SI" do
    unit = Unit.J
    unit.is_si?.should == true
  end

  it "should recognise newton as SI" do
    unit = Unit.N
    unit.is_si?.should == true
  end

  it "should recognise kilometre as SI" do
    unit = Unit.kilometre
    unit.is_si?.should == true
  end

  it "should recognise foot as non SI" do
    unit = Unit.ft
    unit.is_si?.should_not == true
  end

  it "should recognise dram as non SI" do
    unit = Unit.dram
    unit.is_si?.should_not == true
  end

  it "should recognise BTU as non SI" do
    unit = Unit.british_thermal_unit
    unit.is_si?.should_not == true
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
    unit.alternatives[0].symbol.should == :g
  end

  it "should list alternative unit symbols" do
    unit = Unit.kg
    unit.alternatives(:symbol).class.should == Array
    unit.alternatives(:symbol)[0].is_a?(Symbol).should == true
    unit.alternatives(:symbol)[0].should == :g
  end

  it "should list alternative unit names" do
    unit = Unit.kg
    unit.alternatives(:name).class.should == Array
    unit.alternatives(:name)[0].is_a?(Symbol).should == true
    unit.alternatives(:name)[0].should == :gram
  end

  it "should multiply units" do
    kilometre = Unit.km
    hour = Unit.h
    new = kilometre / hour
    new.measures.should == :velocity
  end

  it "should divide units" do
    kilowatt = Unit.kW
    hour = Unit.h
    new = kilowatt * hour
    new.measures.should == :energy
  end

  it "should multiply units" do
    length_1 = Unit.m
    length_2 = Unit.m
    new = length_1 * length_2
    new.measures.should == :area
  end

  it "should divide units" do
    energy = Unit.J
    length = Unit.m
    new = energy / length
    new.measures.should == :force
  end
end

