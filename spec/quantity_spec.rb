# encoding: UTF-8
require 'quantify'
include Quantify

describe Quantity do

  describe "#initialize" do
    specify { Quantity.new(1).should eq(Quantity.new(1,'unity')) }
    specify { Quantity.new(nil,nil).should eq(Quantity.new(nil,'unity')) }
    specify { Quantity.new(nil,nil).should eq(Quantity.new(nil,'unity')) }
    specify { Quantity.new(nil,'unity').should eq(Quantity.new(nil,'unity')) }
    specify { Quantity.new(nil).should eq(Quantity.new(nil,'unity')) }
  end

  it "should fail fast on invalid value input" do
    expect{ Quantity.new('invalid', 'kg') }.to raise_error ArgumentError
  end

  it "should fail fast on invalid unit input" do
    expect{ Quantity.new(1, 'invalid unit') }.to raise_error ArgumentError
  end

  it "should create a valid instance with nil values" do
    quantity = Quantity.new nil, nil
    quantity.value.should be_nil
    quantity.unit.should eq(Unit.for('unity'))
  end

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

  it "should create valid instances with class parse method" do
    quantities = Quantity.parse "10m driving and 5 tonnes carried"
    quantities.should be_a Array
    quantities.first.value.should == 10
    quantities.first.unit.symbol.should == 'm'
    quantities.last.value.should == 5
    quantities.last.unit.symbol.should == 't'
  end

  it "should create a valid instance with class parse method" do
    quantities = Quantity.parse "10 m"
    quantities.first.value.should == 10
    quantities.first.unit.symbol.should == 'm'
  end

  it "should create a valid instance with class parse method" do
    quantities = Quantity.parse "155.6789 ly"
    quantities.first.value.should == 155.6789
    quantities.first.unit.name.should == 'light year'
    quantities.first.represents.should == 'length'
  end

  it "should create a valid instance with class parse method and per unit with symbols" do
    quantities = Quantity.parse "10 m / h"
    quantities.first.value.should == 10
    quantities.first.unit.symbol.should == 'm/h'
  end

  it "should create a valid instance with class parse method and per unit with names" do
    quantities = Quantity.parse "10 miles / hour"
    quantities.first.value.should == 10
    quantities.first.unit.symbol.should == 'mi/h'
  end

  it "should create a valid instance with class parse method and compound per unit with names" do
    quantities = Quantity.parse "10 kilograms / tonne kilometre"
    quantities.first.value.should == 10
    quantities.first.unit.symbol.should == 'kg/t km'
  end

  it "should create a valid instance with class parse method and compound per unit with symbols" do
    quantities = Quantity.parse "10 kg / t km"
    quantities.first.value.should == 10
    quantities.first.unit.symbol.should == 'kg/t km'
  end

  it "should create a valid instance from complex string with compound per unit" do
    quantities = Quantity.parse "We sent some freight 6000 nautical miles by ship and the emissions rate was 10 kg / t km"
    quantities.first.value.should == 6000
    quantities.first.unit.name.should == 'nautical mile'
    quantities.first.unit.symbol.should == 'nmi'
    quantities[1].value.should == 10
    quantities[1].unit.pluralized_name.should == 'kilograms per tonne kilometre'
    quantities[1].unit.symbol.should == 'kg/t km'
  end
  
  it "should create a valid instance from complex string with compound per unit and no spaces" do
    quantities = Quantity.parse "We sent some freight 6000 nautical miles by ship and the emissions rate was 10 kg/t km"
    quantities.first.value.should == 6000
    quantities.first.unit.name.should == 'nautical mile'
    quantities.first.unit.symbol.should == 'nmi'
    quantities[1].value.should == 10
    quantities[1].unit.pluralized_name.should == 'kilograms per tonne kilometre'
    quantities[1].unit.symbol.should == 'kg/t km'
  end

  it "should create valid instances from complex string" do
    quantities = Quantity.parse "I travelled 220 miles driving my car and using 0.13 UK gallons per mile of diesel"
    quantities.first.value.should == 220
    quantities.first.unit.name.should == 'mile'
    quantities.first.unit.symbol.should == 'mi'
    quantities[1].value.should == 0.13
    quantities[1].unit.pluralized_name.should == 'UK gallons per mile'
    quantities[1].unit.symbol.should == 'gal/mi'
  end

  it "should create valid instances from easy string" do
    quantities = Quantity.parse "100km"
    quantities.first.value.should == 100
    quantities.first.unit.name.should == 'kilometre'
  end


  it "should create a valid instance with unity unit from an empty string" do
    quantities = Quantity.parse " "
    quantities.first.value.should == nil
    quantities.first.unit.name.should == 'unity'
  end

  it "should create valid instances from complex string, no space and two-digit symbol" do
    quantities = Quantity.parse "100km driving cars"
    quantities.first.value.should == 100
    quantities.first.unit.name.should == 'kilometre'
  end

  it "should create valid instances from complex string with punctuation" do
    quantities = Quantity.parse "66666 kg; 5 lb; 86 gigagrams per kelvin and some more words"
    quantities.first.value.should == 66666
    quantities.first.unit.name.should == 'kilogram'
    quantities[1].value.should == 5
    quantities[1].unit.pluralized_name.should == 'pounds'
    quantities[1].unit.symbol.should == 'lb'
    quantities[2].value.should == 86
    quantities[2].unit.pluralized_name.should == 'gigagrams per kelvin'
    quantities[2].unit.symbol.should == 'Gg/K'
  end

  it "should create valid instances from complex string with punctuation" do
    quantities = Quantity.parse "6 kilogram square metre per second^2"
    quantities.first.value.should == 6
    quantities.first.unit.name.should == 'kilogram square metre per square second'
  end
  
  it "should create valid instances from complex string with punctuation" do
    quantities = Quantity.parse "I make 1 cup of tea with 1 tea bag, 0.3 litres of water, 10 g of sugar and 1 dram of milk"
    quantities.first.value.should == 1
    quantities.first.unit.name.should == 'cup'
    quantities[1].value.should == 1
    quantities[1].unit.name.should == ''
    quantities[2].value.should == 0.3
    quantities[2].unit.name.should == 'litre'
    quantities[3].value.should == 10
    quantities[3].unit.name.should == 'gram'
    quantities[4].value.should == 1
    quantities[4].unit.name.should == 'dram'
  end

  it "should create valid instances from complex string with indices" do
    quantities = Quantity.parse "I sprayed 500 litres of fertilizer across 6000 m^2 of farmland"
    quantities.first.value.should == 500
    quantities.first.unit.name.should == 'litre'
    quantities.first.unit.symbol.should == 'L'
    quantities[1].value.should == 6000
    quantities[1].unit.pluralized_name.should == 'square metres'
    quantities[1].unit.symbol.should == 'm²'
  end
  
  it "should create valid instance from string with 'square' prefix descriptor" do
    quantities = Quantity.parse "25 square feet"
    quantities.first.value.should == 25
    quantities.first.unit.name.should == 'square foot'
    quantities.first.unit.symbol.should == 'ft²'
  end
  
  it "should create valid instance from string with 'cubic' prefix descriptor" do
    quantities = Quantity.parse "25 cubic feet"
    quantities.first.value.should == 25
    quantities.first.unit.name.should == 'cubic foot'
    quantities.first.unit.symbol.should == 'ft³'
  end
  
  it "should create valid instance from string with 'squared' suffix descriptor" do
    quantities = Quantity.parse "25 feet squared"
    quantities.first.value.should == 25
    quantities.first.unit.name.should == 'square foot'
    quantities.first.unit.symbol.should == 'ft²'
  end
  
  it "should return dimensionless quantity when 'squared' suffix used without a unit" do
    quantities = Quantity.parse "25 squared"
    quantities.first.value.should == 25
    quantities.first.unit.name.should == ''
    quantities.first.unit.symbol.should == ''
  end
  
  it "should return unsquared quantity when 'squared' suffix used unrelated to unit" do
    quantities = Quantity.parse "25 grams some more text and then squared"
    quantities.first.value.should == 25
    quantities.first.unit.name.should == 'gram'
    quantities.first.unit.symbol.should == 'g'
  end
  
  it "should return unsquared quantity when 'square' suffix used" do
    quantities = Quantity.parse "25 grams square"
    quantities.first.value.should == 25
    quantities.first.unit.name.should == 'gram'
    quantities.first.unit.symbol.should == 'g'
  end
  
  it "should return dimensionless quantity when 'square' prefix used without a unit" do
    quantities = Quantity.parse "25 square"
    quantities.first.value.should == 25
    quantities.first.unit.name.should == ''
    quantities.first.unit.symbol.should == ''
  end
  
  it "should return dimensionless quantity when 'cubed' suffix used without a unit" do
    quantities = Quantity.parse "25 cubed"
    quantities.first.value.should == 25
    quantities.first.unit.name.should == ''
    quantities.first.unit.symbol.should == ''
  end
  
  it "should return dimensionless quantity when 'cubic' prefix used without a unit" do
    quantities = Quantity.parse "25 cubic"
    quantities.first.value.should == 25
    quantities.first.unit.name.should == ''
    quantities.first.unit.symbol.should == ''
  end
  
  it "should create valid instance from string with 'cubed' suffix descriptor" do
    quantities = Quantity.parse "25 feet cubed"
    quantities.first.value.should == 25
    quantities.first.unit.name.should == 'cubic foot'
    quantities.first.unit.symbol.should == 'ft³'
  end

  it "should create valid instances from complex string with no spaces" do
    quantities = Quantity.parse "I sprayed 500L of fertilizer across 6000m^2 of farmland"
    quantities.first.value.should == 500
    quantities.first.unit.name.should == 'litre'
    quantities.first.unit.symbol.should == 'L'
    quantities[1].value.should == 6000
    quantities[1].unit.pluralized_name.should == 'square metres'
    quantities[1].unit.symbol.should == 'm²'
  end

  it "should create a valid instance with class parse method and per unit" do
    quantities = Quantity.parse "10 miles / hour"
    quantities.first.value.should == 10
    quantities.first.unit.symbol.should == 'mi/h'
  end

  it "should create a valid instance with class parse method and return remainders" do
    quantities = Quantity.parse "I sprayed 500L of fertilizer across 6000m^2 of farmland", :remainder => true
    quantities.first.should be_a Array
    quantities.first[0].value.should == 500
    quantities.first[0].unit.name.should == 'litre'
    quantities.first[0].unit.symbol.should == 'L'
    quantities.first[1].value.should == 6000
    quantities.first[1].unit.pluralized_name.should == 'square metres'
    quantities.first[1].unit.symbol.should == 'm²'
    quantities[1].should be_a Array
    quantities[1].size.should eql 3
    quantities[1][0].should eql "I sprayed"
    quantities[1][1].should eql "of fertilizer across"
    quantities[1][2].should eql "of farmland"
  end
  
  it "should parse using string method" do
    "20 m".to_q.first.value.should == 20.0
    "45.45 BTU".to_q.first.class.should == Quantity
    "65 kilometres per hour".to_q.first.unit.class.should == Unit::Compound
  end

  it "should create a valid instance with class parse method based on to_string method" do
    quantity_1 = Quantity.new 15, :watt
    quantity_2 = Quantity.parse quantity_1.to_s
    quantity_2.first.value.should == 15
    quantity_2.first.unit.name.should == 'watt'
    quantity_2.first.represents.should == 'power'
  end

  it "should create a valid instance with class parse method and unit prefix based on to_string method" do
    quantity_1 = Quantity.new 15, :watt
    quantity_2 = Quantity.parse quantity_1.to_s
    quantity_2.first.value.should == 15
    quantity_2.first.unit.name.should == 'watt'
    quantity_2.first.represents.should == 'power'
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

  it "should throw error when adding nil quantities" do
    lambda{Quantity.new(nil,nil) + 5.kg}.should raise_error
  end

  it "should subtract quantities correctly with different units of same dimension" do
    result = (125.4.kelvin - -211.85.degree_celsius)
    result.value.should be_within(0.00000001).of(64.1)
    result.unit.symbol.should == "K"
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

  it "should throw error when subtracting nil quantities" do
    lambda{Quantity.new(nil,nil) - 5.kg}.should raise_error
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

  it "should raise error when multiplying by nil quantity" do
    lambda{Quantity.new(nil,nil) * 5.kg}.should raise_error
    lambda{5.kg * Quantity.new(nil,nil)}.should raise_error
  end

  it "should multiply two quantities" do
    quantity = (20.metre * 1.metre)
    quantity.value.should == 20
    quantity.unit.measures.should == 'area'
  end

  it "should successfully divide a quantity by a scalar" do
    (20.metre / 5).to_s.should == "4.0 m"
  end

  it "should throw ZeroDivisionError error when dividing a quantity by '0'" do
    lambda{2.kg / 0}.should raise_error ZeroDivisionError
  end

  it "should NOT throw ZeroDivisionError error when multiplying a quantity by '0'" do
    lambda{2.kg * 0}.should_not raise_error ZeroDivisionError
  end

  it "should multiply a quantity by '0'" do
    (2.kg * 0).to_s.should == "0.0 kg"
  end

  it "should successfully divide a quantity by a scalar" do
    (2.kg / 0.5).round.to_s.should == "4 kg"
  end

  it "should throw error when dividing nil quantities" do
    lambda{Quantity.new(nil,nil) / 5.kg}.should raise_error
    lambda{5.kg / Quantity.new(nil,nil)}.should raise_error
  end

  it "should calculate speed from distance and time quantities" do
    distance_in_km = 12.km
    time_in_min = 16.5.min
    distance_in_miles = distance_in_km.to_miles
    time_in_hours = time_in_min.to_hours
    speed = distance_in_miles / time_in_hours
    speed.class.should == Quantity
    # use #be_within to tolerate Ruby 1.8.7 - 1.9.2 differences
    speed.value.should be_within(1.0e-08).of(27.1143792976291)
    speed.unit.pluralized_name.should eql "miles per hour"
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
    quantity = 6000.BTU.to_megajoules
    # use #be_within to tolerate Ruby 1.8.7 - 1.9.2 differences
    quantity.value.should be_within(1.0e-08).of(6.328824)
    quantity.unit.pluralized_name.should eql "megajoules"
  end

  it "should convert standard units correctly" do
    quantity = 13.1.stones.to_kg
    # use #be_within to tolerate Ruby 1.8.7 - 1.9.2 differences
    quantity.value.should be_within(1.0e-08).of(83.1888383)
    quantity.unit.pluralized_name.should eql "kilograms"
  end

  specify "converting a nil quantity to another unit yields nil" do
    Quantity.new(nil,nil).to_kg.should be_nil
  end

  it "should raise error when trying to round a nil quantity" do
    lambda{Quantity.new(nil,nil).round(2)}.should raise_error
  end

  it "should convert compound units correctly" do
    speed = Quantity.new 100, (Unit.km/Unit.h)
    speed.to_mi.round(2).to_s.should == "62.14 mi/h"
  end

  it "should convert to SI unit correctly" do
    100.cm.to_si.to_s.should == "1.0 m"

    quantity = 2.kWh.to_si
    # use #be_within to tolerate Ruby 1.8.7 - 1.9.2 differences
    quantity.value.should be_within(1.0e-08).of(7200000.0)
    quantity.unit.symbol.should eql "J"

    400.ha.to_si.to_s.should == "4000000.0 m²"
    35.degree_celsius.to_si.to_s.should == "308.15 K"
  end

  it "should convert compound units to SI correctly" do
    speed = Quantity.new 100, (Unit.mi/Unit.h)
    speed.to_si.to_s(:name).should == "44.704 metres per second"
  end

  it "should convert compound units to SI correctly" do
    speed = Quantity.new 100, (Unit.km/Unit.h)
    speed.to_si.value.should be_within(0.0000000000001).of(27.7777777777778)
    speed.to_si.unit.name.should == "metre per second"
  end

  it "should convert compound units to SI correctly" do
    pressure = Quantity.new 100, (Unit.pound_force_per_square_inch)
    pressure.to_si.round.to_s(:name).should == "689476 pascals"
  end

  it "should return equivalent unit according to specification" do
    (50.square_metres/10.m).to_s.should == "5.0 m"
    (1.kg*20.m*2.m/4.s/5.s).to_s(:name).should == '2.0 joules'
    (80.kg/2.m/4.s/5.s).to_s(:name).should == '2.0 pascals'
  end

  it "should raise error when trying to raise a nil quantity to a power" do
    lambda{Quantity.new(nil,nil) ** 2}.should raise_error
    lambda{Quantity.new(nil,nil).pow(2)}.should raise_error
  end

  it "should raise a quantity to a power correctly" do
    unit = 50.ft ** 2
    unit.to_s.should == "2500.0 ft²"
    unit = 50.ft ** 3
    unit.to_s.should == "125000.0 ft³"
    unit = 50.ft ** -1
    unit.to_s.should == "0.02 ft^-1"
    unit = (10.m/1.s)**2
    unit.to_s.should == "100.0 m²/s²"
    unit = (10.m/1.s)**-1
    unit.to_s.should == "0.1 s/m"
    lambda{ ((10.m/1.s)** 0.5) }.should raise_error
  end

  it "should raise a quantity to a power correctly" do
    (50.ft.pow! 2).to_s.should == "2500.0 ft²"
    (50.ft.pow! 3).to_s.should == "125000.0 ft³"
    (50.ft.pow! -1).to_s.should == "0.02 ft^-1"
    ((10.m/1.s).pow! 2).to_s.should == "100.0 m²/s²"
    ((10.m/1.s).pow! -1).to_s.should == "0.1 s/m"
    lambda{ ((10.m/1.s).pow! 0.5) }.should raise_error
  end

  it "should cancel by base units of original compound unit if necessary" do
    quantity = Quantity.new(20, Unit.psi).to(Unit.inches_of_mercury)
    quantity.unit.base_units.size.should == 1
    # use #be_within to tolerate Ruby 1.8.7 - 1.9.2 differences
    quantity.value.should be_within(1.0e-08).of(40.720412743579)
    quantity.unit.symbol.should eql "inHg"
  end

  it "should rationalize units and return new quantity" do
    quantity = 12.yards*36.feet
    quantity.to_s.should eql "432.0 yd ft"
    new_quantity=quantity.rationalize_units
    quantity.to_s.should eql "432.0 yd ft"
    new_quantity.value.should be_within(0.0000001).of(144)
    new_quantity.unit.symbol.should eql  "yd²"
  end

  it "should rationalize units and modify value in place" do
    quantity = 12.yards*36.feet
    quantity.to_s.should eql "432.0 yd ft"
    quantity.rationalize_units!
    quantity.value.should be_within(0.0000001).of(144)
    quantity.unit.symbol.should eql  "yd²"
  end

  context "comparing nil quantities" do

    context "when comparing with non-nil quantities" do
      specify "greater than" do
        lambda{Quantity.new(nil,nil) > 1.m}.should raise_error
      end

      specify "greater than or equals" do
        lambda{Quantity.new(nil,nil) >= 1.m}.should raise_error
      end

      specify "less than" do
        lambda{Quantity.new(nil,nil) < 1.m}.should raise_error
      end

      specify "less than or equals" do
        lambda{Quantity.new(nil,nil) <= 1.m}.should raise_error
      end

      specify "equals" do
        lambda{Quantity.new(nil,nil) == 1.m}.should raise_error
      end

      specify "between" do
        lambda{Quantity.new(nil,nil).between? 1.ft,10.m}.should raise_error NoMethodError
        lambda{Quantity.new(nil,nil).between? Quantity.new(nil,nil),Quantity.new(nil,nil)}.should raise_error NoMethodError
      end

      specify "range" do
        expect{(Quantity.new(nil)..1.kg)}.to raise_error
        expect{(1.kg..Quantity.new(nil))}.to raise_error
      end
    end

    context "when comparing with another nil quantity" do
      specify "greater than" do
        (Quantity.new(nil) > Quantity.new(nil)).should be_false
      end

      specify "greater than or equals" do
        (Quantity.new(nil) >= Quantity.new(nil)).should be_true
      end

      specify "less than" do
        (Quantity.new(nil) < Quantity.new(nil)).should be_false
      end

      specify "less than or equals" do
        (Quantity.new(nil) <= Quantity.new(nil)).should be_true
      end

      specify "equals" do
        (Quantity.new(nil) == Quantity.new(nil)).should be_true
      end

      specify "range" do
        (Quantity.new(nil)..Quantity.new(nil)).should eq(Quantity.new(nil,'unity')..Quantity.new(nil, 'unity'))
      end
    end

  end

  it "should be greater than" do
    (20.ft > 1.m).should be_true
  end

  it "should be greater than" do
    (20.ft > 7.m).should be_false
  end

  it "should be less than" do
    (20.ft/1.h < 8.yd/60.min).should be_true
  end

  it "should be equal" do
    (1.yd == 3.ft).should be_true
  end

  it "should be between with same units" do
    (25.ft.between? 1.ft,30.ft).should be_true
  end

  it "should be between even with different units" do
    (25.ft.between? 1.ft,10.m).should be_true
  end

  it "comparison with non quantity should raise error" do
    lambda{20.ft > 3}.should raise_error
  end

  it "comparison with non compatible quantity should raise error" do
    lambda{20.ft > 4.K}.should raise_error
  end

  it "should be range" do
    (2.ft..20.ft).should be_a Range
  end

  it "should return between value from range" do
    (2.ft..20.ft).cover?(3.ft).should be_true
  end

  it "should return between value from range with different units" do
    (2.ft..4.m).cover?(200.cm).should be_true
    (1.ly..1.parsec).cover?(2.ly).should be_true
    (1.ly..1.parsec).cover?(2.in).should be_false
  end

  it "should return between value from range using === operator" do
    (3.ft === (2.ft..20.ft)).should be_true
  end

  it "should return between value from range with different units using === operator" do
    (200.cm === (2.ft..4.m)).should be_true
    (2.ly === (1.ly..1.parsec)).should be_true
    (2.in === (1.ly..1.parsec)).should be_false
  end

  it "range comparison with non compatible quantity should raise error" do
    lambda{20.ft === (1.ft..3.K)}.should raise_error
  end

  it "range comparison with non quantity should raise error" do
    lambda{20.ft === (1.ft..3)}.should raise_error
  end

  specify "a range with one nil quantity raises an error" do
    lambda{Quantity.new(nil)..20.ft}.should raise_error
  end

  specify "cover? with nil quantities raises an error" do
    lambda{(2.ft..20.ft).cover?(Quantity.new(nil))}.should raise_error
  end

  it "should return unit consolidation setting" do
    Quantity.auto_consolidate_units?.should be_false
  end

  it "should set unit consolidation setting" do
    Quantity.auto_consolidate_units?.should be_false

    Quantity.auto_consolidate_units=true
    Quantity.auto_consolidate_units?.should be_true

    Quantity.auto_consolidate_units=false
    Quantity.auto_consolidate_units?.should be_false
  end

  it "should return non-consolidated units if consolidation disabled" do
    quantity = 20.L * 1.km * (5.lb / 1.L)
    quantity.to_s.should eql "100.0 L km lb/L"
  end

  it "should return equivalent units if consolidation disabled" do
    quantity = 20.L * (5.lb / 1.L)
    quantity.to_s.should eql "100.0 lb"
  end

  it "should return equivalent units if consolidation enabled" do
    Quantity.auto_consolidate_units=true
    quantity = 20.L * (5.lb / 1.L)
    quantity.to_s.should eql "100.0 lb"
  end

  it "should return consolidated units if enabled" do
    Quantity.auto_consolidate_units=true
    quantity = 20.L * 1.km * (5.lb / 1.L)
    quantity.to_s.should eql "100.0 km lb"
  end

  it "should return consolidated units if enabled" do
    
  end
end

