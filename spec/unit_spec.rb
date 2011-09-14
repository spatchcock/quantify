require 'quantify'
include Quantify

describe Unit do

  describe "superscript configuration" do

    after :all do
      Unit.use_superscript_characters!
    end

    it "should initialize superscript format" do
      Unit.use_superscript_characters?.should be_true
    end

    it "should set superscript usage to true" do
      Unit.use_superscript_characters=true
      Unit.use_superscript_characters?.should be_true
    end

    it "should set superscript usage to false" do
      Unit.use_superscript_characters=false
      Unit.use_superscript_characters?.should be_false
    end
    
  end

  describe "unit identifiers" do

    describe "default configuration" do

      it "should know that superscripts are to be used" do
        Unit.use_superscript_characters?.should be_true
      end

      it "should use superspt characters for powers of 2 and 3 by default" do
        Unit.use_superscript_characters?.should be_true
        Unit.cubic_metre.label.should eql 'm³'
        Unit.square_metre.label.should eql 'm²'
        (Unit.m**2).label.should eql 'm²'
        (Unit.kg**3).label.should eql 'kg³'
        unit = (Unit.m*Unit.m*Unit.K*Unit.K)/(Unit.s**3)
        unit.label.should eql 'm²·K²/s³'
        unit = unit*Unit.m
        unit.label.should eql 'm³·K²/s³'
        unit = unit*Unit.m
        unit.label.should eql 'm^4·K²/s³'
      end
      
      it "should recognize and get unit with alternative syntax" do
        Unit.for("m^2").label.should eql 'm²'
        Unit.for("km^2").label.should eql 'km²'
        Unit.for("Gg^3").label.should eql 'Gg³'
        (Unit.Gg**3).label.should eql 'Gg³'
      end

      it "parsing complex unit strings with any syntax should work" do
        Unit.parse("m^4·K²/s³").label.should eql 'm^4·K²/s³'
        Unit.parse("m^4 K²/s³").label.should eql 'm^4·K²/s³'
        Unit.parse("m^4 K^2/s^3").label.should eql 'm^4·K²/s³'
        Unit.parse("m^4 K^2 s^-3").label.should eql 'm^4·K²/s³'

        Unit.parse("m^4·K²/s³").symbol.should eql 'm^4 K²/s³'
        Unit.parse("m^4 K²/s³").symbol.should eql 'm^4 K²/s³'
        Unit.parse("m^4 K^2/s^3").symbol.should eql 'm^4 K²/s³'
        Unit.parse("m^4 K^2 s^-3").symbol.should eql 'm^4 K²/s³'

        Unit.parse("m^4·K²/s³").name.should eql 'metre to the 4th power square kelvin per cubic second'
        Unit.parse("m^4 K²/s³").name.should eql 'metre to the 4th power square kelvin per cubic second'
        Unit.parse("m^4 K^2/s^3").name.should eql 'metre to the 4th power square kelvin per cubic second'
        Unit.parse("m^4 K^2 s^-3").name.should eql 'metre to the 4th power square kelvin per cubic second'
      end

    end

    describe "explicitly turning off superscript characters" do

      before :all do
        Unit.use_superscript_characters=false
      end

      after :all do
        Unit.use_superscript_characters!
      end

      it "should know that superscripts are not to be used" do
        Unit.use_superscript_characters?.should be_false
      end

      it "should NOT use superscript characters for powers of 2 and 3" do
        Unit.cubic_metre.label.should eql 'm^3'
        Unit.square_metre.label.should eql 'm^2'
        (Unit.m**2).label.should eql 'm^2'
        (Unit.kg**3).label.should eql 'kg^3'
        unit = (Unit.m*Unit.m*Unit.K*Unit.K)/(Unit.s**3)
        unit.label.should eql 'm^2·K^2/s^3'
        unit = unit*Unit.m
        unit.label.should eql 'm^3·K^2/s^3'
        unit = unit*Unit.m
        unit.label.should eql 'm^4·K^2/s^3'
      end

      it "should recognize and get unit with alternative syntax" do
        Unit.for("m²").label.should eql "m^2"
        Unit.for('km²').label.should eql "km^2"
        Unit.for('Gg³').label.should eql "Gg^3"
        (Unit.Gg**3).label.should eql "Gg^3"
      end

      it "parsing complex unit strings with any syntax should work" do
        Unit.parse("m^4·K²/s³").label.should eql "m^4·K^2/s^3"
        Unit.parse("m^4 K²/s³").label.should eql "m^4·K^2/s^3"
        Unit.parse("m^4 K^2/s^3").label.should eql "m^4·K^2/s^3"
        Unit.parse("m^4 K^2 s^-3").label.should eql "m^4·K^2/s^3"


        Unit.parse("m^4·K²/s³").symbol.should eql 'm^4 K^2/s^3'
        Unit.parse("m^4 K²/s³").symbol.should eql 'm^4 K^2/s^3'
        Unit.parse("m^4 K^2/s^3").symbol.should eql 'm^4 K^2/s^3'
        Unit.parse("m^4 K^2 s^-3").symbol.should eql 'm^4 K^2/s^3'

        Unit.parse("m^4·K²/s³").name.should eql 'metre to the 4th power square kelvin per cubic second'
        Unit.parse("m^4 K²/s³").name.should eql 'metre to the 4th power square kelvin per cubic second'
        Unit.parse("m^4 K^2/s^3").name.should eql 'metre to the 4th power square kelvin per cubic second'
        Unit.parse("m^4 K^2 s^-3").name.should eql 'metre to the 4th power square kelvin per cubic second'
      end

    end

    describe "explicitly turning on superscript characters" do

      before :all do
        Unit.use_superscript_characters=false
        Unit.use_superscript_characters=true
      end

      it "should know that superscripts are to be used" do
        Unit.use_superscript_characters?.should be_true
      end

      it "should use superscript characters for powers of 2 and 3" do
        Unit.cubic_metre.label.should eql 'm³'
        Unit.square_metre.label.should eql 'm²'
        (Unit.m**2).label.should eql 'm²'
        (Unit.kg**3).label.should eql 'kg³'
        unit = (Unit.m*Unit.m*Unit.K*Unit.K)/(Unit.s**3)
        unit.label.should eql 'm²·K²/s³'
        unit = unit*Unit.m
        unit.label.should eql 'm³·K²/s³'
        unit = unit*Unit.m
        unit.label.should eql 'm^4·K²/s³'
      end
      
      it "should recognize and get unit with alternative syntax" do
        Unit.for("m^2").label.should eql 'm²'
        Unit.for("km^2").label.should eql 'km²'
        Unit.for("Gg^3").label.should eql 'Gg³'
        (Unit.Gg**3).label.should eql 'Gg³'
      end

      it "parsing complex unit strings with any syntax should work" do
        Unit.parse("m^4·K²/s³").label.should eql 'm^4·K²/s³'
        Unit.parse("m^4 K²/s³").label.should eql 'm^4·K²/s³'
        Unit.parse("m^4 K^2/s^3").label.should eql 'm^4·K²/s³'
        Unit.parse("m^4 K^2 s^-3").label.should eql 'm^4·K²/s³'

        Unit.parse("m^4·K²/s³").symbol.should eql 'm^4 K²/s³'
        Unit.parse("m^4 K²/s³").symbol.should eql 'm^4 K²/s³'
        Unit.parse("m^4 K^2/s^3").symbol.should eql 'm^4 K²/s³'
        Unit.parse("m^4 K^2 s^-3").symbol.should eql 'm^4 K²/s³'

        Unit.parse("m^4·K²/s³").name.should eql 'metre to the 4th power square kelvin per cubic second'
        Unit.parse("m^4 K²/s³").name.should eql 'metre to the 4th power square kelvin per cubic second'
        Unit.parse("m^4 K^2/s^3").name.should eql 'metre to the 4th power square kelvin per cubic second'
        Unit.parse("m^4 K^2 s^-3").name.should eql 'metre to the 4th power square kelvin per cubic second'
      end

    end

    describe "explicitly turning on superscript characters with bang! method" do

      before :all do
        Unit.use_superscript_characters=false
        Unit.use_superscript_characters!
      end

      it "should know that superscripts are to be used" do
        Unit.use_superscript_characters?.should be_true
      end

      it "should use superscript characters for powers of 2 and 3" do
        Unit.cubic_metre.label.should eql 'm³'
        Unit.square_metre.label.should eql 'm²'
        (Unit.m**2).label.should eql 'm²'
        (Unit.kg**3).label.should eql 'kg³'
        unit = (Unit.m*Unit.m*Unit.K*Unit.K)/(Unit.s**3)
        unit.label.should eql 'm²·K²/s³'
        unit = unit*Unit.m
        unit.label.should eql 'm³·K²/s³'
        unit = unit*Unit.m
        unit.label.should eql 'm^4·K²/s³'
      end

      it "should recognize and get unit with alternative syntax" do
        Unit.for("m^2").label.should eql 'm²'
        Unit.for("km^2").label.should eql 'km²'
        Unit.for("Gg^3").label.should eql 'Gg³'
        (Unit.Gg**3).label.should eql 'Gg³'
      end

      it "parsing complex unit strings with any syntax should work" do
        Unit.parse("m^4·K²/s³").label.should eql 'm^4·K²/s³'
        Unit.parse("m^4 K²/s³").label.should eql 'm^4·K²/s³'
        Unit.parse("m^4 K^2/s^3").label.should eql 'm^4·K²/s³'
        Unit.parse("m^4 K^2 s^-3").label.should eql 'm^4·K²/s³'

        Unit.parse("m^4·K²/s³").symbol.should eql 'm^4 K²/s³'
        Unit.parse("m^4 K²/s³").symbol.should eql 'm^4 K²/s³'
        Unit.parse("m^4 K^2/s^3").symbol.should eql 'm^4 K²/s³'
        Unit.parse("m^4 K^2 s^-3").symbol.should eql 'm^4 K²/s³'

        Unit.parse("m^4·K²/s³").name.should eql 'metre to the 4th power square kelvin per cubic second'
        Unit.parse("m^4 K²/s³").name.should eql 'metre to the 4th power square kelvin per cubic second'
        Unit.parse("m^4 K^2/s^3").name.should eql 'metre to the 4th power square kelvin per cubic second'
        Unit.parse("m^4 K^2 s^-3").name.should eql 'metre to the 4th power square kelvin per cubic second'
      end

    end

    describe "identifier case" do

      it "should ignore case when initialising units by name" do
        Unit.METRE.label.should eql 'm'
        Unit.metre.label.should eql 'm'
        Unit.KiLoMeTrE.label.should eql 'km'
      end

      it "should NOT ignore case when initialising units by symbol" do
        Unit.m.label.should eql 'm'
        lambda{Unit.M}.should raise_error
        Unit.Gg.name.should eql 'gigagram'
        lambda{Unit.GG}.should raise_error
      end

      it "should NOT ignore case when initialising units by label" do
        Unit.ton_us.label.should eql 'ton_us'
        lambda{Unit.TON_US}.should raise_error
      end

    end

  end

  describe "unit retrieval" do

    it "symbols list should include" do
      list = Unit.units_by_symbol
      list.should include 'η'
      list.should include 'g'
      list.should include 'kg'
      list.should include '°C'
      list.should include 'K'
      list.should include 'yd'
      list.should include 'ly'
      list.should include 'AU'
      list.should include 'lb'
      list.should include 'eV'
    end

    it "symbols list should not include these" do
      Unit.units_by_symbol.should_not include 'zz'
    end

    it "si symbols list should include" do
      list = Unit.si_units_by_symbol
      list.should include 'η'
      list.should include 'kg'
      list.should include 'K'
    end

    it "si symbols list should not include" do
      list = Unit.si_units_by_symbol
      list.should_not include '°C'
      list.should_not include 'yd'
      list.should_not include 'ly'
      list.should_not include 'AU'
      list.should_not include 'lb'
      list.should_not include 'eV'
    end

    it "non si symbols list should include" do
      list = Unit.non_si_units_by_symbol
      list.should include '°C'
      list.should include 'yd'
      list.should include 'ly'
      list.should include 'AU'
      list.should include 'lb'
      list.should include 'eV'
    end

    it "non si symbols list should not include" do
      list = Unit.non_si_units_by_symbol
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
      Unit::Prefix::NonSI.load(:name => 'million ', :symbol => 'MM', :factor => 1e6)
      Unit.MMBTU.name.should == 'million british thermal unit (59 °F)'
      Unit::Prefix.unload :MM
    end

    it "dynamic unit retrieval with symbol and invalid prefix should raise error" do
      lambda{Unit.MMm}.should raise_error
      lambda{Unit.Gft}.should raise_error
      lambda{Unit.centimetre.with_prefix :kilo}.should raise_error
    end

    it "explicit get should raise nil if not known" do
      Unit.for(:MMm).should be_nil
      Unit.for(:andrew).should be_nil
      Unit.for(nil).should be_nil
    end

    it "empty string should return nil" do
      Unit.for("").should be_nil
    end

    it "should recognize m²" do
      Unit.for("m²").should be_a Unit::Base
    end

    it "should recognise unit with single word name" do
      Unit.centimetre.symbol.should eql "cm"
    end

    it "should recognise unit with multiple word name" do
      Unit.centimetre_of_mercury.symbol.should eql "cmHg"
    end

    it "should recognise unit with single word pluralized name" do
      Unit.centimetres.symbol.should eql "cm"
    end

    it "should recognise unit with multiple word pluralized name" do
      Unit.centimetres_of_mercury.symbol.should eql "cmHg"
    end

    it "should recognise compound unit with single word name" do
      Unit.centimetre_per_hour.symbol.should eql "cm/h"
    end

    it "should recognise compound unit with multiple word name" do
      Unit.centimetre_of_mercury_per_hour.symbol.should eql "cmHg/h"
    end

    it "should recognise compound unit with single word pluralized name" do
      Unit.centimetres_per_hour.symbol.should eql "cm/h"
    end

    it "should recognise compound unit with multiple word pluralized name" do
      Unit.centimetres_of_mercury_per_hour.symbol.should eql "cmHg/h"
    end

    it "should recognise compound unit with single word name" do
      Unit.centimetre_per_hour_US_bushel.symbol.should eql "cm/h bu (Imp)"
    end

    it "should recognise compound unit with multiple word name" do
      Unit.centimetre_of_mercury_per_hour_US_bushel.symbol.should eql "cmHg/h bu (Imp)"
    end

    it "should recognise compound unit with single word pluralized name" do
      Unit.centimetres_per_hour_US_bushels.symbol.should eql "cm/h bu (Imp)"
    end

    it "should recognise compound unit with multiple word pluralized name" do
      Unit.centimetres_of_mercury_per_hour_US_bushels.symbol.should eql "cmHg/h bu (Imp)"
    end
    
    describe "parsing unit string" do
      
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
      
      it "should parse per unit correctly" do
        unit = Unit.parse "s^-1"
        unit.name.should == 'per second'
      end

      it "should raise error when parsing on unknown units" do
        lambda{unit = Unit.parse "kg z^2"}.should raise_error
      end
    
    end
    
    it "should create new instance with block initialize" do
      unit = Unit::Base.new do |unit|
        unit.name = 'megapanda'
        unit.symbol = 'Mpd'
        unit.label = 'Mpd'
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

    it "should modify unit attributes with block and #configure" do
      unit = (Unit.kg/Unit.kWh).configure do |u|
        u.name = 'electricity emissions factor'
      end
      unit.class.should == Quantify::Unit::Compound
      unit.name = 'electricity emissions factor'
    end

    it "should raise error with block and #configure which removes name" do
      lambda{(Unit.kg/Unit.kWh).configure do |u|
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
      unit = Unit::Base.new :physical_quantity => :mass, :name => 'gigapile', :symbol => 'Gpl', :label => 'Gpl'
      unit.class.should == Quantify::Unit::Base
    end

    it "should allow dimensions to be specified with :dimensions key" do
      unit = Unit::Base.new :dimensions => :mass, :name => 'gigapile', :symbol => 'Gpl', :label => 'Gpl'
      unit.class.should == Quantify::Unit::Base
    end

    it "should mass load units with prefixes" do
      Unit::SI.prefix_and_load([:kilo,:mega,:giga,:tera],[:metre,:gram,:second])
      Unit.kilometre.loaded?.should == true
      Unit.gigametre.loaded?.should == true
      Unit.kilogram.loaded?.should == true
      Unit.teragram.loaded?.should == true
      Unit.kilosecond.loaded?.should == true
      Unit.nanometre.loaded?.should == false
    end

    it "should mass load unit with prefixes" do
      Unit::SI.prefix_and_load([:kilo,:mega,:giga,:tera],:metre)
      Unit.kilometre.loaded?.should == true
      Unit.gigametre.loaded?.should == true
      Unit.nanometre.loaded?.should == false
    end

    it "should mass load units with prefix" do
      Unit::SI.prefix_and_load(:giga,[:metre,:gram,:second])
      Unit.gigametre.loaded?.should == true
      Unit.gigagram.loaded?.should == true
      Unit.gigasecond.loaded?.should == true
      Unit.nanometre.loaded?.should == false
    end

    it "should mass load units with prefix using objects as arguments" do
      Unit::SI.prefix_and_load(Unit::Prefix.giga,[Unit.metre,Unit.gram,Unit.second])
      Unit.gigametre.loaded?.should == true
      Unit.gigagram.loaded?.should == true
      Unit.gigasecond.loaded?.should == true
      Unit.nanometre.loaded?.should == false
    end

    it "should unload unit with class method and symbol" do
      Unit.nanometre.load
      Unit.nanometre.loaded?.should == true
      Unit.unload(:nanometre)
      Unit.nanometre.loaded?.should == false
    end

    it "should unload unit with class method and object" do
      Unit.nanometre.load
      Unit.nanometre.loaded?.should == true
      Unit.unload(Unit.nanometre)
      Unit.nanometre.loaded?.should == false
    end

    it "should unload unit with instance method" do
      Unit.nanometre.load
      Unit.nanometre.loaded?.should == true
      unit = Unit.nanometre
      unit.unload
      Unit.nanometre.loaded?.should == false
    end

    it "should unload multiple units with class method" do
      Unit.nanometre.load
      Unit.picometre.load
      Unit.nanometre.loaded?.should == true
      Unit.picometre.loaded?.should == true
      Unit.unload(:nanometre,:picometre)
      Unit.nanometre.loaded?.should == false
      Unit.picometre.loaded?.should == false
    end

    it "should make new unit configuration canonical" do
      unit = Unit.psi
      unit.name.should == 'pound force per square inch'
      unit.configure {|unit| unit.name = 'PSI'}
      unit.name.should == 'PSI'
      Unit.psi.name.should == 'pound force per square inch'
      unit.make_canonical
      Unit.psi.name.should == 'PSI'
      unit.configure {|unit| unit.name = 'pound force per square inch'}
      unit.make_canonical
    end

    it "should change the label of canonical unit representation" do
      unit = Unit.cubic_metre
      unit.label.should eql "m³"
      unit.canonical_label = "m3"
      unit.label.should eql "m3"
      Unit.cubic_metre.label.should eql "m3"
    end

    it "should configure on canonical unit" do
      unit = Unit.kg.configure_as_canonical do |unit|
        unit.name = 'killogram'
      end
      unit.name.should eql 'killogram'
      unit.symbol.should eql 'kg'
      Unit.kg.name.should eql 'killogram'
      (Unit.killogram).should be_a Unit::Base

      unit = Unit.kg.configure_as_canonical do |unit|
        unit.name = 'kilogram'
      end
    end

    it "should configure on canonical unit even if changing label" do
      unit = Unit.barn.configure_as_canonical do |unit|
        unit.label = 'BARN'
      end
      unit.label.should eql 'BARN'
      unit.symbol.should eql 'b'
      Unit.barn.label.should eql 'BARN'
      (Unit.BARN).should be_a Unit::Base

      unit = Unit.barn.configure_as_canonical do |unit|
        unit.label = 'b'
      end
    end

    it "should configure on canonical unit even if changing label using canonical_label=" do
      unit = Unit.barn.configure_as_canonical do |unit|
        unit.canonical_label = 'BARN'
      end
      unit.label.should eql 'BARN'
      unit.symbol.should eql 'b'
      Unit.barn.label.should eql 'BARN'
      (Unit.BARN).should be_a Unit::Base

      unit = Unit.barn.configure_as_canonical do |unit|
        unit.label = 'b'
      end
    end

  end

  describe "unit initialization" do

    it "should load self into module variable with instance method" do
      unit = Unit::Base.new :physical_quantity => :mass, :name => 'megalump', :symbol => 'Mlp', :label => 'Mlp'
      unit.load
      Unit.units_by_symbol.should include 'Mlp'
      Unit.units_by_name.should include 'megalump'
    end

    it "should create unit" do
      unit = Unit::NonSI.new :name => 'a name', :physical_quantity => :energy, :factor => 10, :symbol => 'anm', :label => 'a_name'
      unit.class.should == Unit::NonSI
    end

    it "should throw error when creating unit with no name" do
      lambda{unit = Unit::NonSI.new :physical_quantity => :energy, :factor => 10}.should raise_error
    end

    it "should throw error when creating unit with no physical quantity" do
      lambda{unit = Unit::NonSI.new :name => 'energy', :factor => 10}.should raise_error
    end

    it "should load unit into module array with class method" do
      unit = Unit::NonSI.load :name => 'a name', :physical_quantity => :energy, :factor => 10, :symbol => 'anm', :label => 'a_name'
      Unit.non_si_units_by_name.should include 'a name'
      Unit.unload(unit)
    end

    it "should load unit into module array with class method and block" do
      Unit::NonSI.load do |unit|
        unit.name = 'a name'
        unit.physical_quantity = :energy
        unit.factor = 10
        unit.symbol = 'anm'
        unit.label = 'a_name'
      end
      Unit.non_si_units_by_name.should include 'a name'
      Unit.a_name.measures.should eql 'energy'
      Unit.unload('a_name')
    end

    it "should load unit into module array with class method and block and #dimensions method" do
      Unit::NonSI.load do |unit|
        unit.name = 'a name'
        unit.dimensions = :energy
        unit.factor = 10
        unit.symbol = 'anm'
        unit.label = 'a_name'
      end
      Unit.non_si_units_by_name.should include 'a name'
      Unit.a_name.measures.should eql 'energy'
      Unit.unload('a_name')
    end
    
    it "should derive compound unit correctly" do
      Unit::Prefix::NonSI.load(:name => 'million ', :symbol => 'MM', :factor => 1e6)
      (Unit.MW_h/Unit.MMBTU).factor.should be_close 3.41295634070405, 0.00000001
      Unit::Prefix.unload :MM
    end

  end

  describe "unit scaling attribute" do

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

  end

  describe "unit physical quantity" do

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

  end

  describe "unit self awareness" do

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

    it "should recognise dram as non SI" do
      unit = Unit.dram
      unit.is_si_unit?.should_not == true
    end

    it "should recognise BTU as non SI" do
      unit = Unit.BTU
      unit.is_si_unit?.should_not == true
    end

    it "should recognise a compound unit" do
      (Unit.m*Unit.t).is_compound_unit?.should == true
      Unit.m.is_compound_unit?.should == false
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
    
    it "compound unit should be recognsed as Unit::Base and Compound" do
      unit = Unit.m*Unit.kg*Unit.s
      unit.is_a?(Unit::Base).should be_true
      unit.is_a?(Unit::Compound).should be_true
      unit.is_a?(Unit::SI).should_not be_true
      unit.is_a?(Unit::NonSI).should_not be_true
    end

  end

  describe "alternative units" do

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

    it "should recognise similar units" do
      unit_1 = Unit.yard
      unit_2 = Unit.yard
      unit_1.is_equivalent_to?(unit_2).should == true
    end

    it "should recognise non-similar units" do
      unit_1 = Unit.yard
      unit_2 = Unit.foot
      unit_1.is_equivalent_to?(unit_2).should_not == true
    end

    it "should recognise non-similar units" do
      unit_1 = Unit.yard
      unit_2 = Unit.kelvin
      (unit_1.is_equivalent_to? unit_2).should_not == true
    end

    it "should recognise known units from compound units based on dimensions and factor" do
      unit = Unit.kg*Unit.m*Unit.m/Unit.s/Unit.s
      unit.equivalent_known_unit.name.should == 'joule'
    end

    it "megagram and tonne should be similar" do
      tonne = Unit.t
      tonne.symbol.should == 't'
      tonne.factor.should == 1000.0
      megagram = Unit.Mg
      megagram.symbol.should == 'Mg'
      megagram.factor.should == 1000.0
      megagram.is_equivalent_to?(tonne).should be_true
    end

    it "should return correct SI unit" do
      Unit.ft.si_unit.name.should == 'metre'
      Unit.lb.si_unit.name.should == 'kilogram'
      Unit.BTU.si_unit.name.should == 'joule'
      (Unit.ft**2).si_unit.name.should == 'square metre'
      Unit.pounds_force_per_square_inch.si_unit.name.should == 'pascal'
    end

    it "should not return alternative if feature disabled" do
      alt = Unit.kg.alternatives
      alt.class.should == Array
      alt[0].is_a?(Unit::Base).should == true
      alt.any?{|unit| unit == Unit.g }.should == true

      Unit.g.acts_as_alternative_unit = false

      alt = Unit.kg.alternatives
      alt.class.should == Array
      alt[0].is_a?(Unit::Base).should == true
      alt.any?{|unit| unit == Unit.g }.should == false

      Unit.g.acts_as_alternative_unit = true

      alt = Unit.kg.alternatives
      alt.class.should == Array
      alt[0].is_a?(Unit::Base).should == true
      alt.any?{|unit| unit == Unit.g }.should == true
    end

  end

  describe "operating on units" do

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

    it "should raise unit to power" do
      (Unit.m**3).measures.should == 'volume'
    end

    it "coerce method should handle reciprocal syntax" do
      (1/Unit.s).name.should == 'per second'
    end

    it "should raise to power -1" do
      (Unit.s**-1).dimensions.time.should == -1
    end

    it "should raise to power -2" do
      unit = Unit.m**-2
      unit.name.should == 'per square metre'
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

  end

  describe "handling prefixes" do

    it "should throw error when trying to add prefix to prefixed-unit" do
      lambda{Unit.kilometre.with_prefix :giga}.should raise_error
    end

    it "should add prefix with explcit method" do
      Unit.metre.with_prefix(:c).name.should == 'centimetre'
    end
    
    it "trying to add invalid prefix should raise error" do
      lambda{Unit.ft.with_prefix(:kilo)}.should raise_error
    end

  end

  describe "specific units" do

    it "should represent the pound mole correctly" do
      unit = Unit.lbmol
      unit.name.should eql 'pound mole'
      Unit.ratio(Unit.mol,unit).value.should eql 453.59237
      unit.alternatives_by_name.should eql ['mole']
    end
  end

end

