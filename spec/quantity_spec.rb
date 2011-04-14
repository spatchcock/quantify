require 'quantify'
include Quantify

describe Quantity do

  it "should create a valid instance with standard create and unit name" do
    quantity = Quantity.new 10.0, 'metre'
    quantity.value.should == 10
    quantity.unit.symbol.should == 'm'
  end

  it "should create a valid instance with standard create and unit name" do
    quantity = Quantity.new 5000, :kilowatt
    quantity.value.should == 5000
    quantity.unit.symbol.should == 'kW'
  end

  it "should create a valid instance with standard create and unit symbol" do
    quantity = Quantity.new 5000, 'kW'
    quantity.value.should == 5000
    quantity.unit.name.should == 'kilowatt'
  end

  it "should create a valid instance with dynamic create and unit name" do
    quantity = 10.metre
    quantity.value.should == 10
    quantity.unit.symbol.should == 'm'
  end

  it "should create a valid instance with dynamic create and unit symbol" do
    quantity = 10.km
    quantity.value.should == 10
    quantity.unit.name.should == 'kilometre'
  end

  it "should create a valid instance with class parse method" do
    quantity = Quantity.parse "10 m"
    quantity.value.should == 10
    quantity.unit.symbol.should == 'm'
  end

  it "should create a valid instance with class parse method" do
    quantity = Quantity.parse "155.6789 ly"
    quantity.value.should == 155.6789
    quantity.unit.name.should == 'light year'
    quantity.represents.should == 'length'
  end

  it "should create a valid instance with class parse method based on to_string method" do
    quantity_1 = Quantity.new 15, :watt
    quantity_2 = Quantity.parse quantity_1.to_s
    quantity_2.value.should == 15
    quantity_2.unit.name.should == 'watt'
    quantity_2.represents.should == 'power'
  end

  it "should create a valid instance with class parse method and unit prefix based on to_string method" do
    quantity_1 = Quantity.new 15, :watt
    quantity_2 = Quantity.parse quantity_1.to_s
    quantity_2.value.should == 15
    quantity_2.unit.name.should == 'watt'
    quantity_2.represents.should == 'power'
  end

  it "should convert quantity correctly" do
    1.km.to_metre.unit.symbol.should == 'm'
    1.km.to_metre.to_s.should == "1000.0 m"
  end

  it "should convert quantity correctly" do
    1.BTU.to_joule.to_s.should == "1054.804 J"
  end

  it "should convert quantity correctly" do
    1.hour.to_second.to_s.should == "3600.0 s"
  end

  it "should convert quantity correctly with scaling (temperature)" do
    85.degree_farenheit.to_degree_celsius.round.to_s.should == "29 °C"
  end

  it "should convert quantity correctly with scaling (temperature) and with decimal places" do
    85.degree_farenheit.to_degree_celsius.round(2).to_s.should == "29.44 °C"
  end

  it "should add quantities correctly with same units" do
    (5.metre + 3.metre).to_s.should == "8.0 m"
  end

  it "should add quantities correctly with same units" do
    (125.4.kelvin + 61.3.K).to_s.should == "186.7 K"
  end

  it "should add quantities correctly with different units of same dimension" do
    (15.foot + 5.yd).to_s.should == "30.0 ft"
  end

  it "should add quantities correctly with different units of same dimension" do
    (125.4.kelvin + -211.85.degree_celsius).to_s.should == "186.7 K"
  end

  it "should throw error when adding quantities with different dimensions" do
    lambda{1.metre + 5.kg}.should raise_error
  end

  it "should subtract quantities correctly with different units of same dimension" do
    (125.4.kelvin - -211.85.degree_celsius).to_s.should == "64.1 K"
  end

  it "should subtract quantities correctly with different units of same dimension" do
    (300.foot - 50.yard).round.to_s.should == "150 ft"
  end

  it "should subtract quantities correctly with same units" do
    (300.foot - 100.ft).round.to_s.should == "200 ft"
  end

  it "should throw error when subtracting quantities with different dimensions" do
    lambda{1.metre - 5.kg}.should raise_error
  end

  it "should successfully multiply a quantity by a scalar" do
    (20.metre * 3).to_s.should == "60.0 m"
  end

  it "should successfully multiply a quantity by a scalar" do
    (2.kg * 50).round.to_s.should == "100 kg"
  end

  it "should raise error if multiplying by string" do
    lambda{20.metre * '3'}.should raise_error
  end

  it "should two quantities" do
    quantity = (20.metre * 1.metre)
    quantity.value.should == 20
    quantity.unit.measures.should == 'area'
  end

  it "should successfully divide a quantity by a scalar" do
    (20.metre / 5).to_s.should == "4.0 m"
  end

  it "should successfully divide a quantity by a scalar" do
    (2.kg / 0.5).round.to_s.should == "4 kg"
  end

  it "should calculate speed from distance and time quantities" do
    distance_in_km = 12.km
    time_in_min = 16.5.min
    distance_in_miles = distance_in_km.to_miles
    time_in_hours = time_in_min.to_hours
    speed = distance_in_miles / time_in_hours
    speed.class.should == Quantity
    speed.value.should be_close 27.1143792976291, 0.00000001
    speed.to_s(:name).should == "27.1143792976291 miles per hour"
    speed.to_s.should == "27.1143792976291 mi h^-1"
  end

  it "coerce method should handle inverted syntax" do
    quantity = 1/2.ft
    quantity.to_s.should == "0.5 ft^-1"
    quantity.to_s(:name).should == "0.5 per foot"
  end

  it "should convert temperature correctly" do
    30.degree_celsius.to_K.to_s.should == "303.15 K"
  end

  it "should convert temperature correctly" do
    30.degree_celsius.to_degree_farenheit.round.to_s.should == "86 °F"
  end

  it "should convert standard units correctly" do
    27.feet.to_yards.round.to_s(:name).should == "9 yards"
  end

  it "should convert standard units correctly" do
    6000.BTU.to_megajoules.to_s(:name).should == "6.328824 megajoules"
  end

  it "should convert standard units correctly" do
    13.1.stones.to_kg.to_s(:name).should == "83.1888383 kilograms"
  end

  it "should convert compound units correctly" do
    speed = Quantity.new 100, (Unit.km/Unit.h)
    speed.to_mi.round(2).to_s.should == "62.14 mi h^-1"
  end

  it "should convert to SI unit correctly" do
    100.cm.to_si.to_s.should == "1.0 m"
    2.kWh.to_si.to_s.should == "7200000.0 J"
    400.ha.to_si.to_s.should == "4000000.0 m^2"
    35.degree_celsius.to_si.to_s.should == "308.15 K"
  end

  it "should convert compound units to SI correctly" do
    speed = Quantity.new 100, (Unit.mi/Unit.h)
    speed.to_si.to_s(:name).should == "44.704 metres per second"
  end

  it "should convert compound units to SI correctly" do
    pressure = Quantity.new 100, (Unit.pound_force_per_square_inch)
    pressure.to_si.round.to_s(:name).should == "689476 newtons per square metre"
  end

  it "should return equivalent unit according to specification" do
    (50.square_metres/10.m).to_s.should == "5.0 m"
    (1.kg*20.m*2.m/4.s/5.s).to_s(:name).should == '2.0 joules'
    (80.kg/2.m/4.s/5.s).to_s(:name).should_not == '2.0 pascals'
  end

  it "should raise a quantity to a power correctly" do
    unit = 50.ft ** 2
    unit.to_s.should == "2500.0 ft^2"
    unit = 50.ft ** 3
    unit.to_s.should == "125000.0 ft^3"
    unit = 50.ft ** -1
    unit.to_s.should == "0.02 ft^-1"
    unit = (10.m/1.s)**2
    unit.to_s.should == "100.0 m^2 s^-2"
    unit = (10.m/1.s)**-1
    unit.to_s.should == "0.1 s m^-1"
    lambda{ ((10.m/1.s)** 0.5) }.should raise_error
  end

  it "should raise a quantity to a power correctly" do
    (50.ft.pow! 2).to_s.should == "2500.0 ft^2"
    (50.ft.pow! 3).to_s.should == "125000.0 ft^3"
    (50.ft.pow! -1).to_s.should == "0.02 ft^-1"
    ((10.m/1.s).pow! 2).to_s.should == "100.0 m^2 s^-2"
    ((10.m/1.s).pow! -1).to_s.should == "0.1 s m^-1"
    lambda{ ((10.m/1.s).pow! 0.5) }.should raise_error
  end

  it "should parse using string method" do
    "20 m".to_q.value.should == 20.0
    "45.45 BTU".to_q.class.should == Quantity
    "65 kilometres per hour".to_q.unit.class.should == Unit::Compound
    "65 kilometre per hour".to_q.unit.class.should == Unit::Compound
  end
end

