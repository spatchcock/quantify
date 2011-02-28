require 'quantify'
include Quantify

describe Quantity do

  it "should create a valid instance with standard create and unit name" do
    quantity = Quantity.new 10.0, 'metre'
    quantity.value.should == 10
    quantity.unit.symbol.should == :m
  end

  it "should create a valid instance with standard create and unit name" do
    quantity = Quantity.new 5000, 'kilowatt'
    quantity.value.should == 5000
    quantity.unit.symbol.should == :kW
  end

  it "should create a valid instance with standard create and unit symbol" do
    quantity = Quantity.new 5000, 'kW'
    quantity.value.should == 5000
    quantity.unit.name.should == :kilowatt
  end

  it "should create a valid instance with dynamic create and unit name" do
    quantity = 10.metre
    quantity.value.should == 10
    quantity.unit.symbol.should == :m
  end

  it "should create a valid instance with dynamic create and unit symbol" do
    quantity = 10.km
    quantity.value.should == 10
    quantity.unit.name.should == :kilometre
  end

  it "should create a valid instance with class parse method" do
    quantity = Quantity.parse "10 m"
    quantity.value.should == 10
    quantity.unit.symbol.should == :m
  end

  it "should create a valid instance with class parse method" do
    quantity = Quantity.parse "155.6789 ly"
    quantity.value.should == 155.6789
    quantity.unit.name.should == :light_year
    quantity.represents.should == :length
  end

  it "should create a valid instance with class parse method based on to_string method" do
    quantity_1 = Quantity.new 15, :watt
    quantity_2 = Quantity.parse quantity_1.to_s
    quantity_2.value.should == 15
    quantity_2.unit.name.should == :watt
    quantity_2.represents.should == :power
  end

  it "should create a valid instance with class parse method and unit prefix based on to_string method" do
    quantity_1 = Quantity.new 15, :watt
    quantity_2 = Quantity.parse quantity_1.to_s
    quantity_2.value.should == 15
    quantity_2.unit.name.should == :watt
    quantity_2.represents.should == :power
  end

  it "should convert quantity correctly" do
    1.km.to_metre.unit.symbol.should == :m
    1.km.to_metre.to_s.should == "1000.0 m"
  end

  it "should convert quantity correctly" do
    1.BTU.to_joule.to_s.should == "1055.056 J"
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
    quantity.unit.measures.should == :area
  end

  it "should successfully divide a quantity by a scalar" do
    (20.metre / 5).to_s.should == "4.0 m"
  end

  it "should successfully divide a quantity by a scalar" do
    (2.kg / 0.5).round.to_s.should == "4 kg"
  end
end

