include Quantify

# Configure known dimensions, prefixes and units.
# Order must be maintained for initialization of all objects to be successful:
#
#  * dimensions,
#  * prefixes,
#  * units.
#

Dimensions.configure do

  # Load the standard, widely-recognised physical quantities.
  # Base quantities
  load :physical_quantity => 'mass', :mass => 1
  load :physical_quantity => 'length', :length => 1
  load :physical_quantity => 'time', :time => 1
  load :physical_quantity => 'electric current', :electric_current => 1
  load :physical_quantity => 'temperature', :temperature => 1
  load :physical_quantity => 'luminous intensity', :luminous_intensity => 1
  load :physical_quantity => 'amount of substance', :amount_of_substance => 1
  load :physical_quantity => 'information', :information => 1
  load :physical_quantity => 'currency', :currency => 1
  load :physical_quantity => 'item', :item => 1
  load :physical_quantity => 'dimensionless'

  # Derived quantities, i.e. combinations of 1 or more base quantities and
  # powers thereof.
  load :physical_quantity => 'acceleration', :length => 1, :time => -2
  load :physical_quantity => 'area', :length => 2
  load :physical_quantity => 'action', :mass => 1, :length => 2, :time => -1
  load :physical_quantity => 'angular monentum', :length => 2, :mass => 1, :time => -1
  load :physical_quantity => 'conductivity', :length => -3, :mass => -1, :time => 3, :electric_current => 2
  load :physical_quantity => 'density', :mass => 1, :length => -3
  load :physical_quantity => 'electric charge', :electric_current => 1, :time => 1
  load :physical_quantity => 'electric charge_density', :electric_current => 1, :time => 1, :length => -3
  load :physical_quantity => 'electric conductance', :electric_current => 2, :time => 3, :mass => -1, :length => -2
  load :physical_quantity => 'electric displacement', :length => -2, :time => 1, :electric_current => 1
  load :physical_quantity => 'electric field strength', :length => 1, :mass => 1, :time => -3, :electric_current => -1
  load :physical_quantity => 'electric polarisability', :mass => -1, :time => 4, :electric_current => 2
  load :physical_quantity => 'electric polarisation', :length => -2, :time => 1, :electric_current => 1
  load :physical_quantity => 'electric potential difference', :mass => 1, :length => 2, :electric_current => -1, :time => -3
  load :physical_quantity => 'electric resistance', :mass => 1, :length => 2, :electric_current => -2, :time => -3
  load :physical_quantity => 'electrical capacitance', :electric_current => 2, :time => 4, :mass => -1, :length => -2
  load :physical_quantity => 'energy', :mass => 1, :length => 2, :time => -2
  load :physical_quantity => 'entropy', :length => 2, :mass => 1, :time => -2, :temperature => -1
  load :physical_quantity => 'force', :length => 1, :mass => 1, :time => -2
  load :physical_quantity => 'frequency', :time => -1
  load :physical_quantity => 'heat capacity', :length => 2, :mass => 1, :time => -2, :temperature => -1
  load :physical_quantity => 'illuminance', :luminous_intensity => 1, :length => -2
  load :physical_quantity => 'impedance', :length => 2, :mass => 1, :time => -3, :electric_current => -2
  load :physical_quantity => 'inductance', :mass => 1, :length => 2, :time => -2, :electric_current => -2
  load :physical_quantity => 'irradiance', :mass => 1, :time => -3
  load :physical_quantity => 'luminous flux', :luminous_intensity => 1
  load :physical_quantity => 'magnetic field strength', :length => -1, :electric_current => 1
  load :physical_quantity => 'magnetic flux', :mass => 1, :length => 2, :time => -2, :electric_current => -1
  load :physical_quantity => 'magnetic flux density', :mass => 1, :electric_current => -1, :time => -2
  load :physical_quantity => 'magnetic dipole moment', :length => 2, :electric_current => 1
  load :physical_quantity => 'magnetic vector potential', :mass => 1, :length => 1, :time => -2, :electric_current => -1
  load :physical_quantity => 'magnetisation', :length => -1, :electric_current => 1
  load :physical_quantity => 'moment of inertia', :length => 2, :mass => 1
  load :physical_quantity => 'momentum', :length => 1, :mass => 1, :time => -1
  load :physical_quantity => 'number density', :item => 1, :length => -3
  load :physical_quantity => 'permeability', :mass => 1, :length => 1, :time => -2, :electric_current => -2
  load :physical_quantity => 'permittivity', :mass => -1, :length => -3, :time => 4, :electric_current => 2
  load :physical_quantity => 'plane angle' # length / length = dimensionsless
  load :physical_quantity => 'power', :mass => 1, :length => 2, :time => -3
  load :physical_quantity => 'pressure', :mass => 1, :length => -1, :time => -2
  load :physical_quantity => 'radiation absorbed dose', :length => 2, :time => -2
  load :physical_quantity => 'radiation dose equivalent', :length => 2, :time => -2
  load :physical_quantity => 'radioactivity', :time => -1
  load :physical_quantity => 'solid angle' # area / area = dimensionless
  load :physical_quantity => 'surface tension', :mass => 1, :time => -2
  load :physical_quantity => 'velocity', :length => 1, :time => -1
  load :physical_quantity => 'dynamic viscosity', :length => -1, :mass => 1, :time => -1
  load :physical_quantity => 'kinematic viscosity', :length => 2, :time => -1
  load :physical_quantity => 'volume', :length => 3
  load :physical_quantity => 'energy density', :length => -1, :mass => 1, :time => -2
  load :physical_quantity => 'thermal resistance', :temperature => 1, :mass => -1, :time => 3
  load :physical_quantity => 'catalytic activity', :amount_of_substance => 1, :time => -1

end

Prefix::SI.configure do

  # SI prefixes
  load :name => 'deca', :symbol => 'da', :factor => 1e1
  load :name => 'hecto', :symbol => 'h', :factor => 1e2
  load :name => 'kilo', :symbol => 'k', :factor => 1e3
  load :name => 'mega', :symbol => 'M', :factor => 1e6
  load :name => 'giga', :symbol => 'G', :factor => 1e9
  load :name => 'tera', :symbol => 'T', :factor => 1e12
  load :name => 'peta', :symbol => 'P', :factor => 1e15
  load :name => 'exa', :symbol => 'E', :factor => 1e18
  load :name => 'zetta', :symbol => 'Z', :factor => 1e21
  load :name => 'yotta', :symbol => 'Y', :factor => 1e24
  load :name => 'deci', :symbol => 'd', :factor => 1e-1
  load :name => 'centi', :symbol => 'c', :factor => 1e-2
  load :name => 'milli', :symbol => 'm', :factor => 1e-3
  load :name => 'micro', :symbol => 'μ', :factor => 1e-6
  load :name => 'nano', :symbol => 'n', :factor => 1e-9
  load :name => 'pico', :symbol => 'p', :factor => 1e-12
  load :name => 'femto', :symbol => 'f', :factor => 1e-15
  load :name => 'atto', :symbol => 'a', :factor => 1e-18
  load :name => 'zepto', :symbol => 'z', :factor => 1e-21
  load :name => 'yocto', :symbol => 'y', :factor => 1e-24

end

Prefix::NonSI.configure do

  # This prefix is used to represent 1 million British Thermal Units. It
  # derives from the 'M' prefix which is used to represent 1 thousand (and is
  # presumably based on Roman numerals). The latter prefix is not defined here
  # since it conflicts directly with the SI prefix for 1 million (mega; M).
  #
  # The 'MM' prefix is considered bad practice, but is nevertheless commonly
  # used in the US, so is added here to provide this support.
  load :name => 'million ', :symbol => 'MM', :factor => 1e6
  load :name => 'billion ', :symbol => 'B', :factor => 1e9

end

Unit::SI.configure do

  # Load SI units.
  #
  # Conversion factors between units are specified relative to the standard -
  # SI - units and therefore these implicitly represent a factor of 1.
  #
  # This is initialized by default in the Unit class and therefore does not
  # need to be declared here.
  #
  # SI units therefore require only their physical quantity to be specified.
  load :name => 'ampere', :physical_quantity => 'electric_current', :symbol => 'A', :label => 'A'
  # load :name => 'amagat', :physical_quantity => 'number_density', :symbol => 'η'
  load :name => 'bit', :physical_quantity => 'information', :symbol => 'bit', :label => 'bit'
  load :name => 'bequerel', :physical_quantity => 'radioactivity', :symbol => 'Bq', :label => 'Bq'
  load :name => 'candela', :physical_quantity => 'luminous_intensity', :symbol => 'cd', :label => 'cd'
  load :name => 'coloumb', :physical_quantity => 'electric_charge', :symbol => 'C', :label => 'C'
  load :name => 'farad', :physical_quantity => 'electrical_capacitance', :symbol => 'F', :label => 'F'
  load :name => 'gray', :physical_quantity => 'radiation_absorbed_dose', :symbol => 'Gy', :label => 'Gy'
  load :name => 'hertz', :physical_quantity => 'frequency', :symbol => 'Hz', :label => 'Hz'
  load :name => 'henry', :physical_quantity => 'inductance', :symbol => 'H', :label => 'H'
  load :name => 'joule', :physical_quantity => 'energy', :symbol => 'J', :label => 'J'
  load :name => 'katal', :physical_quantity => 'catalytic activity', :symbol => 'kat', :label => 'kat'
  load :name => 'kelvin', :physical_quantity => 'temperature', :symbol => 'K', :label => 'K'
  load :name => 'lumen', :physical_quantity => 'luminous_flux', :symbol => 'lm', :label => 'lm'
  load :name => 'lux', :physical_quantity => 'illuminance', :symbol => 'lx', :label => 'lx'
  load :name => 'metre', :physical_quantity => 'length', :symbol => 'm', :label => 'm'
  load :name => 'mole', :physical_quantity => 'amount_of_substance', :symbol => 'mol', :label => 'mol'
  load :name => 'newton', :physical_quantity => 'force', :symbol => 'N', :label => 'N'
  load :name => 'ohm', :physical_quantity => 'electric_resistance', :symbol => 'Ω', :label => 'Ohm'
  load :name => 'pascal', :physical_quantity => 'pressure', :symbol => 'Pa', :label => 'Pa'
  load :name => 'radian', :physical_quantity => 'plane_angle', :symbol => 'rad', :label => 'rad'
  load :name => 'second', :physical_quantity => 'time', :symbol => 's', :label => 's'
  load :name => 'siemens', :physical_quantity => 'electric_conductance', :symbol => 'S', :label => 'S'
  load :name => 'sievert', :physical_quantity => 'radiation_dose_equivalent', :symbol => 'Sv', :label => 'Sv'
  load :name => 'steridian', :physical_quantity => 'solid_angle', :symbol => 'sr', :label => 'sr'
  load :name => 'tesla', :physical_quantity => 'magnetic_flux_density', :symbol => 'T', :label => 'T'
  load :name => 'volt', :physical_quantity => 'electric_potential_difference', :symbol => 'V', :label => 'V'
  load :name => 'watt', :physical_quantity => 'power', :symbol => 'W', :label => 'W'
  load :name => 'weber', :physical_quantity => 'magnetic_flux', :symbol => 'Wb', :label => 'Wb'

  # The kilogram is unusual in being the SI unit of mass yet containing the
  # 'kilo' prefix.
  #
  # The :gram unit is therefore defined explicitly to act as a base for
  # handling SI prefixes.
  #
  # All mass unit factors are nevertheless specified relative to the SI unit
  # (kilogram), in consistency with all other unit types
  #
  # Kilogram could be defined explcitly here, but given the multiple prefix
  # initialization below (which includes kilogram), the individual assignment for
  # kilogram is commented out here (trying to assign a prefix to a unit which
  # already contains a prefix throws an error)
  #
  load :name => 'kilogram', :physical_quantity => :mass, :symbol => 'kg', :label => 'kg'
  load :name => 'gram', :physical_quantity => 'mass', :factor => 1e-3, :symbol => 'g', :label => 'g'

  # Define units on the base of unit operations
  #
  define(Unit.m**2).load

  define(Unit.m**3).load

  define(Unit.m/Unit.s).load

  define(Unit.m/(Unit.s**2)).load
  
  # add required prefixes individually
  Unit.micrometre.load

  Unit.centiradian.load do |unit|
    unit.label = 'centiradian'
  end

  # Add required prefixes on a multiple basis
  # load_with_prefixes(Unit.si_units,[:kilo,:mega,:giga,:tera])

end

Unit::NonSI.configure do

  # Non-SI units. These units are measures of quantities which do not conform
  # to the SI system. They are therefore represent by a conversion factor which
  # is defined relative to the corresponding SI unit for that quantity.
  #
  # load :name => 'acre', :physical_quantity => 'area', :factor => 4046.8564224
  # load :name => 'abampere', :physical_quantity => 'electric current', :factor => 10.0, :symbol => 'abA'
  # load :name => 'abcoloumb', :physical_quantity => 'electric charge', :factor => 10.0, :symbol => 'abC'
  # load :name => 'abfarad', :physical_quantity => 'electrical capacitance', :factor => 1e9
  # load :name => 'abhenry', :physical_quantity => 'inductance', :factor => 1e-9
  # load :name => 'abhmo', :physical_quantity => 'electric conductance', :factor => 1e9
  # load :name => 'abohm', :physical_quantity => 'electric resistance', :factor => 1e-9
  # load :name => 'abvolt', :physical_quantity => 'electric potential_difference', :factor => 10e-9, :symbol => 'abV'
  load :name => 'angstrom', :physical_quantity => 'length', :factor => 100e-12, :symbol => 'Å', :label => 'Å'
  load :name => 'arcminute', :physical_quantity => 'plane angle', :factor => Math::PI/10800, :symbol => '′', :label => '′'
  load :name => 'arcsecond', :physical_quantity => 'plane angle', :factor => Math::PI/648000, :symbol => '″', :label => '″'
  load :name => 'are', :physical_quantity => 'area', :factor => 100.0, :symbol => 'a', :label => 'a'
  load :name => 'astronomical unit', :physical_quantity => 'length', :factor => 149.5979e9, :symbol => 'AU', :label => 'ua'
  load :name => 'atmosphere', :physical_quantity => 'pressure', :factor => 101.325e3, :symbol => 'atm', :label => 'atm'
  load :name => 'bar', :physical_quantity => 'pressure', :factor => 100e3, :symbol => 'bar', :label => 'bar'
  # load :name => 'barn', :physical_quantity => 'area', :factor => 100e-30, :symbol => 'b'
  # load :name => 'baromil', :physical_quantity => 'length', :factor => 750.1e-6
  # load :name => 'petroleum barrel', :physical_quantity => 'volume', :factor => 158.9873e-3, :symbol => 'bbl'
  # load :name => 'uk barrel', :physical_quantity => 'volume', :factor => 163.6592e-3, :symbol => 'bl (Imp)'
  # load :name => 'us dry barrel', :physical_quantity => 'volume', :factor => 115.6271e-3, :symbol => 'bl (US)'
  # load :name => 'us liquid barrel', :physical_quantity => 'volume', :factor => 119.2405e-3, :symbol => 'fl bl (US)'
  # load :name => 'biot', :physical_quantity => 'electric current', :factor => 10.0, :symbol => 'Bi'
  load :name => 'british thermal unit (59 °F)', :physical_quantity => 'energy', :factor => 1054.804, :symbol => 'BTU', :label => 'BTU_FiftyNineF'
  # The IT (International [Steam] Table) defined BTU is apparently the most widely used so is given the basic name here
  load :name => 'british thermal unit', :physical_quantity => 'energy', :factor => 1055.05585262, :symbol => 'BTU', :label => 'BTU_IT'
  load :name => 'british thermal unit (39 °F)', :physical_quantity => 'energy', :factor => 1059.67, :symbol => 'BTU', :label => 'BTU_ThirtyNineF'
  load :name => 'british thermal unit (mean)', :physical_quantity => 'energy', :factor => 1055.87, :symbol => 'BTU', :label => 'BTU_Mean'
  load :name => 'british thermal unit (ISO)', :physical_quantity => 'energy', :factor => 1055.056, :symbol => 'BTU', :label => 'BTU_ISO'
  load :name => 'british thermal unit (60 °F)', :physical_quantity => 'energy', :factor => 1054.68, :symbol => 'BTU', :label => 'BTU_SixtyF'
  load :name => 'british thermal unit (63 °F)', :physical_quantity => 'energy', :factor => 1054.6, :symbol => 'BTU', :label => 'BTU_SixtyThreeF'
  load :name => 'british thermal unit (thermochemical)', :physical_quantity => 'energy', :factor => 1054.35026444, :symbol => 'BTU', :label => 'BTU_Thermochemical'
  # load :name => 'bushel_uk', :physical_quantity => 'volume', :factor => 36.36872e-3, :symbol => 'bu (Imp)'
  # load :name => 'bushel_us', :physical_quantity => 'volume', :factor => 35.23907e-3, :symbol => 'bu (US lvl)'
  # load :name => 'butt', :physical_quantity => 'volume', :factor => 477.3394e-3
  load :name => 'byte', :physical_quantity => 'information', :factor => 8, :symbol => 'byte', :label => 'byte'
  # load :name => 'cable', :physical_quantity => 'length', :factor => 219.456
  # load :name => 'calorie', :physical_quantity => 'energy', :factor => 4.1868, :symbol => 'cal'
  # load :name => 'candle power', :physical_quantity => 'luminous flux', :factor => 4*Math::PI, :symbol => 'cp'
  # load :name => 'carat', :physical_quantity => 'mass', :factor => 200e-6, :symbol => 'kt'
  # load :name => 'celsius heat unit', :physical_quantity => 'energy', :factor => 1.0899101e3, :symbol => 'CHU'
  # load :name => 'centimetre of mercury', :physical_quantity => 'pressure', :factor => 1.333222e3, :symbol => 'cmHg'
  # load :name => 'centimetre of water', :physical_quantity => 'pressure', :factor => 98.060616, :symbol => 'cmH2O'
  # load :name => 'chain', :physical_quantity => 'length', :factor => 20.1168, :symbol => 'ch'
  # load :name => 'us cup', :physical_quantity => 'volume', :factor => 236.5882e-6, :symbol => 'c (US)'
  load :name => 'curie', :physical_quantity => 'radioactivity', :factor => 37.0e9, :symbol => 'Ci', :label => 'Ci'
  load :name => 'day', :physical_quantity => 'time', :factor => 86.4e3, :symbol => 'd', :label => 'd'
  load :name => 'sidereal day', :physical_quantity => 'time', :factor => 86.16409053e3, :symbol => 'd', :label => 'day_sidereal'
  load :name => 'degree', :physical_quantity => 'plane angle', :factor => Math::PI/180.0, :symbol => '°', :label => '°'
  load :name => 'degree celsius', :physical_quantity => 'temperature', :scaling => 273.15, :symbol => '°C', :label => '°C'
  load :name => 'degree farenheit', :physical_quantity => 'temperature', :factor => 5.0/9.0, :scaling => 459.67, :symbol => '°F', :label => '°F'
  load :name => 'degree rankine', :physical_quantity => 'temperature', :factor => 5.0/9.0, :symbol => '°R', :label => '°R'
  # load :name => 'dram', :physical_quantity => 'length', :factor => 1.771845e-3, :symbol => 'dr av'
  load :name => 'dyne', :physical_quantity => 'force', :factor => 10e-6, :symbol => 'dyn', :label => 'dyn'
  # load :name => 'dyne centimetre', :physical_quantity => 'energy', :factor => 100e-9, :symbol => 'dyn cm'
  load :name => 'electron mass', :physical_quantity => 'mass', :factor => 9.10938188e-31, :symbol => 'me', :label => 'me'
  load :name => 'electron volt', :physical_quantity => 'energy', :factor => 160.218e-21, :symbol => 'eV', :label => 'eV'
  load :name => 'erg', :physical_quantity => 'energy', :factor => 100.0e-9, :symbol => 'erg', :label => 'erg'
  # load :name => 'ell', :physical_quantity => 'length', :factor => 1.143, :symbol => 'ell'
  load :name => 'faraday', :physical_quantity => 'electric charge', :factor => 96.4853e3, :symbol => 'F', :label => 'Fd'
  # load :name => 'fathom', :physical_quantity => 'length', :factor => 1.828804, :symbol => 'fm'
  # load :name => 'fermi', :physical_quantity => 'length', :factor => 1e-15, :symbol => 'fm'
  load :name => 'uk fluid ounce', :physical_quantity => 'volume', :factor => 28.41308e-6, :symbol => 'fl oz', :label => 'oz_fl_uk'
  load :name => 'us fluid ounce', :physical_quantity => 'volume', :factor => 29.57353e-6, :symbol => 'fl oz', :label => 'oz_fl'
  load :name => 'foot', :physical_quantity => 'length', :factor => 0.3048, :symbol => 'ft', :label => 'ft'
  load :name => 'us survey foot', :physical_quantity => 'length', :factor => 304.8e-3, :symbol => 'ft', :label => 'foot_survey_us'
  load :name => 'franklin', :physical_quantity => 'electric charge', :factor => 3.3356e-10, :symbol => 'Fr', :label => 'Fr'
  # load :name => 'foot of water', :physical_quantity => 'pressure', :factor => 2.988887e3, :symbol => 'ftH2O'
  # load :name => 'footcandle', :physical_quantity => :illuminance, :factor => 10.76391, :symbol => 'fc'
  # load :name => 'furlong', :physical_quantity => :length, :factor => 201.168, :symbol => 'fur'
  load :name => 'uk gallon', :physical_quantity => 'volume', :factor => 4.546092, :symbol => 'gal', :label => 'gal_uk'
  load :name => 'us liquid gallon', :physical_quantity => 'volume', :factor => 3.785412, :symbol => 'gal', :label => 'gal'
  load :name => 'us dry gallon', :physical_quantity => 'volume', :factor => 0.00440488377086, :symbol => 'gal', :label => 'gallon_dry_us'
  # load :name => 'gamma', :physical_quantity => 'magnetic flux density', :factor => 1e-9, :symbol => 'γ'
  load :name => 'gauss', :physical_quantity => 'magnetic flux density', :factor => 100e-6, :symbol => 'G', :label => 'G'
  # load :name => 'uk gill', :physical_quantity => 'volume', :factor => 142.0654e-6, :symbol => 'gi'
  # load :name => 'us gill', :physical_quantity => 'volume', :factor => 118.2941e-6, :symbol => 'gi'
  load :name => 'grad', :physical_quantity => 'plane_angle', :factor => Math::PI/200.0, :symbol => 'grad', :label => 'grade'
  # load :name => 'grain', :physical_quantity => 'mass', :factor => 64.79891e-6, :symbol => 'gr'
  # load :name => 'hartree', :physical_quantity => 'energy', :factor => 4.359748e-18, :symbol => 'Eh'
  load :name => 'hectare', :physical_quantity => 'area', :factor => 10e3, :symbol => 'ha', :label => 'ha'
  # load :name => 'hogshead', :physical_quantity => 'volume', :factor => 238.6697e-3, :symbol => 'hhd'
  # load :name => 'boiler horsepower', :physical_quantity => 'power', :factor => 9.80950e3, :symbol => 'bhp'
  # load :name => 'electric horsepower', :physical_quantity => 'power', :factor => 746.0, :symbol => 'hp'
  load :name => 'metric horsepower', :physical_quantity => 'power', :factor => 735.4988, :symbol => 'hp', :label => 'hp'
  # load :name => 'uk horsepower', :physical_quantity => 'power', :factor => 745.6999, :symbol => 'hp'
  load :name => 'hour', :physical_quantity => 'time', :factor => 3.6e3, :symbol => 'h', :label => 'h'
  # load :name => 'hundredweight long', :physical_quantity => 'mass', :factor => 50.802345, :symbol => 'cwt'
  # load :name => 'hundredweight short', :physical_quantity => 'mass', :factor => 45.359237, :symbol => 'cwt'
  load :name => 'inch', :physical_quantity => 'length', :factor => 25.4e-3, :symbol => 'in', :label => 'in'
  load :name => 'inch of mercury', :physical_quantity => 'pressure', :factor => 3.386389e3, :symbol => 'inHg', :label => 'inHg'
  # load :name => 'inch of water', :physical_quantity => 'pressure', :factor => 249.0740, :symbol => 'inH2O'
  # load :name => 'kilocalorie', :physical_quantity => 'energy', :factor => 4.1868e3, :symbol => 'kcal'
  load :name => 'kilowatt hour', :physical_quantity => 'energy', :factor => 3.6e6, :symbol => 'kW h', :label => 'kWh'
  load :name => 'kilogram force', :physical_quantity => 'force', :factor => 9.80665, :symbol => 'kgf', :label => 'kgf'
  load :name => 'knot', :physical_quantity => 'velocity', :factor => 514.4444e-3, :symbol => 'kn', :label => 'kn'
  load :name => 'lambert', :physical_quantity => 'illuminance', :factor => 1e4, :symbol => 'La', :label => 'La'
  # load :name => 'nautical league', :physical_quantity => 'length', :factor => 5.556e3, :symbol => 'nl'
  # load :name => 'statute league', :physical_quantity => 'length', :factor => 4.828032e3, :symbol => 'lea'
  load :name => 'light year', :physical_quantity => 'length', :factor => 9.46073e15, :symbol => 'ly', :label => 'ly'
  # load :name => 'line', :physical_quantity => 'length', :factor => 2.116667e-3, :symbol => 'ln'
  # load :name => 'link', :physical_quantity => 'length', :factor => 201.168e-3, :symbol => 'lnk'
  load :name => 'litre', :physical_quantity => 'volume', :factor => 1e-3, :symbol => 'L', :label => 'L'
  load :name => 'maxwell', :physical_quantity => 'magnetic flux', :factor => 10e-9, :symbol => 'Mx', :label => 'Mx'
  # load :name => 'micron', :physical_quantity => 'length', :factor => 1e-6, :symbol => 'μm'
  load :name => 'minute', :physical_quantity => 'time', :factor => 60.0, :symbol => 'min', :label => 'min'
  load :name => 'mile', :physical_quantity => 'length', :factor => 1.609344e3, :symbol => 'mi', :label => 'mi'
  load :name => 'nautical mile', :physical_quantity => 'length', :factor => 1.852e3, :symbol => 'nmi', :label => 'nmi'
  # load :name => 'millibar', :physical_quantity => 'pressure', :factor => 100, :symbol => 'mbar'
  load :name => 'millimetre of mercury', :physical_quantity => 'pressure', :factor => 1.333222e2, :symbol => 'mmHg', :label => 'mmHg'
  load :name => 'month', :physical_quantity => 'time', :factor => 2.551444e6, :symbol => 'month', :label => 'month'
  load :name => 'ounce', :physical_quantity => 'mass', :factor => 28.34952e-3, :symbol => 'oz', :label => 'oz'
  load :name => 'point', :physical_quantity => 'length', :factor => 351.4598e-6, :symbol => 'pt', :label => 'pt'
  load :name => 'pound', :physical_quantity => 'mass', :factor => 0.45359237, :symbol => 'lb', :label => 'lb'
  load :name => 'parsec', :physical_quantity => 'length', :factor => 30.85678e15, :symbol => 'pc', :label => 'pc'
  # load :name => 'pennyweight', :physical_quantity => 'mass', :factor => 1.555174e-3, :symbol => 'dwt'
  # load :name => 'poncelot', :physical_quantity => 'power', :factor => 980.665, :symbol => 'p'
  # load :name => 'poundal', :physical_quantity => 'force', :factor => 138.255, :symbol => 'pdl'
  load :name => 'pound force', :physical_quantity => 'force', :factor => 4.448222, :symbol => 'lbf', :label => 'lbf'
  # load :name => 'quad', :physical_quantity => 'energy', :factor => 1.055056e18, :symbol => 'quad'
  load :name => 'rad', :physical_quantity => 'radiation absorbed dose', :factor => 0.01, :symbol => 'rad', :label => 'rd'
  load :name => 'revolution', :physical_quantity => 'plane angle', :factor => 2*Math::PI, :symbol => 'rev', :label => 'rev'
  # load :name => 'reyn', :physical_quantity => 'dynamic viscosity', :factor => 689.5e3, :symbol => 'reyn'
  load :name => 'rem', :physical_quantity => 'radiation_dose_equivalent', :factor => 0.01, :symbol => 'rem', :label => 'rem'
  # load :name => 'rood', :physical_quantity => 'area', :factor => 1.011714e3, :symbol => 'rood'
  load :name => 'rutherford', :physical_quantity => 'radioactivity', :factor => 1e6, :symbol => 'rd', :label => 'Rd'
  # load :name => 'rydberg', :physical_quantity => 'energy', :factor => 2.179874e-18, :symbol => 'Ry'
  load :name => 'sphere', :physical_quantity => 'solid angle', :factor => 4*Math::PI, :label => 'sphere'
  # load :name => 'sthene', :physical_quantity => 'force', :factor => 1e3, :symbol => 'sn'
  # load :name => 'stokes', :physical_quantity => 'kinematic viscosity', :factor => 100e-6, :symbol => 'St'
  load :name => 'stone', :physical_quantity => 'mass', :factor => 6.350293, :symbol => 'st', :label => 'st'
  # load :name => 'therm', :physical_quantity => 'energy', :factor => 105.506e6, :symbol => 'thm'
  # load :name => 'thermie', :physical_quantity => 'energy', :factor => 4.185407e6, :symbol => 'th'
  load :name => 'short ton', :physical_quantity => 'mass', :factor => 907.1847, :symbol => 'ton', :label => 'ton_us'
  load :name => 'long ton', :physical_quantity => 'mass', :factor => 1.016047, :symbol => 'ton', :label => 'ton_uk'
  load :name => 'tonne', :physical_quantity => 'mass', :factor => 1000.0, :symbol => 't', :label => 't'
  load :name => 'unified atomic mass', :physical_quantity => 'mass', :factor => 1.66054e-27, :symbol => 'u', :label => 'u'
  load :name => 'week', :physical_quantity => 'time', :factor => 604800, :label => 'week'
  load :name => 'yard', :physical_quantity => 'length', :factor => 0.9144, :symbol => 'yd', :label => 'yd'
  load :name => 'year', :physical_quantity => 'time', :factor => 31557600, :symbol => 'yr', :label => 'year'
  load :name => 'sidereal year', :physical_quantity => 'time', :factor => 31558823.803728, :symbol => 'yr', :label => 'year_sidereal'
  # load :name => 'tog', :physical_quantity => 'thermal resistance', :factor => 0.1, :symbol => 'tog'
  # load :name => 'clo', :physical_quantity => 'thermal resistance', :factor => 0.155, :symbol => 'clo'


end

Unit::Base.configure do

  # Define a unit representing the quantity 1.
  # This can be used to define reciprocal units using division, i.e.
  #
  #   kg^-1   is equivalent to   1/kg   or   <unity>/<kg>
  #
  load :name => 'unity', :physical_quantity => 'dimensionless', :symbol => '1'

  load :name => 'percent', :physical_quantity => 'dimensionless', :symbol => '%'

end

Unit::Compound.configure do

  # Define compound units on the base of the product or quotient of two or more
  # known units.
  #
  # These don't actually need to be generated within this container, but it's
  # tidy

  # kilowatt hour
  #
  # This commented out here and defined as a NonSI unit since AMEE uses the
  # technically incorrect symbol kWh (i.e. no space or middot between kW and h)
  #
  # (Unit.kW * Unit.h).load


  # electricity emissions factor
  # (Unit.kg/Unit.kWh).load

  # reciprocal/inverse units, e.g. inverse length
  (1/Unit.centimetre).load do |unit|
    unit.name = 'inverse centimetre'
  end

  # pounds per square inch
  (Unit.pound_force/(Unit.in**2)).load do |unit|
    unit.symbol = 'psi'
  end

  (Unit.cm/Unit.s/Unit.s).load do |unit|
    unit.name = 'galileo'
    unit.symbol = 'Gal'
    unit.label = 'galileo'
  end

end

Quantify.configure do

  describe_prevailing_unit_rules do |unit,equivalent_unit|
    equivalent_unit.is_base_unit? or
    equivalent_unit.name == 'joule' or
    equivalent_unit.name == 'newton' or
    equivalent_unit.name == 'watt'
  end

end