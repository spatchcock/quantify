include Quantify

# Configure known dimensions, prefixes and units.
# Order must be maintained for initialization of all objects to be successful:
#
#  * dimensions,
#  * prefixes,
#  * units.
#

Dimensions.configure do |config|

  # Load the standard, widely-recognised physical quantities.
  # Base quantities
  config.load :physical_quantity => 'mass', :mass => 1
  config.load :physical_quantity => 'length', :length => 1
  config.load :physical_quantity => 'time', :time => 1
  config.load :physical_quantity => 'electric current', :electric_current => 1
  config.load :physical_quantity => 'temperature', :temperature => 1
  config.load :physical_quantity => 'luminous intensity', :luminous_intensity => 1
  config.load :physical_quantity => 'amount of substance', :amount_of_substance => 1
  config.load :physical_quantity => 'information', :information => 1
  config.load :physical_quantity => 'currency', :currency => 1
  config.load :physical_quantity => 'item', :item => 1
  config.load :physical_quantity => 'dimensionless'

  # Derived quantities, i.e. combinations of 1 or more base quantities and
  # powers thereof.
  config.load :physical_quantity => 'acceleration', :length => 1, :time => -2
  config.load :physical_quantity => 'area', :length => 2
  config.load :physical_quantity => 'action', :mass => 1, :length => 2, :time => -1
  config.load :physical_quantity => 'angular monentum', :length => 2, :mass => 1, :time => -1
  config.load :physical_quantity => 'conductivity', :length => -3, :mass => -1, :time => 3, :electric_current => 2
  config.load :physical_quantity => 'density', :mass => 1, :length => -3
  config.load :physical_quantity => 'electric charge', :electric_current => 1, :time => 1
  config.load :physical_quantity => 'electric charge_density', :electric_current => 1, :time => 1, :length => -3
  config.load :physical_quantity => 'electric conductance', :electric_current => 2, :time => 3, :mass => -1, :length => -2
  config.load :physical_quantity => 'electric displacement', :length => -2, :time => 1, :electric_current => 1
  config.load :physical_quantity => 'electric field strength', :length => 1, :mass => 1, :time => -3, :electric_current => -1
  config.load :physical_quantity => 'electric polarisability', :mass => -1, :time => 4, :electric_current => 2
  config.load :physical_quantity => 'electric polarisation', :length => -2, :time => 1, :electric_current => 1
  config.load :physical_quantity => 'electric potential difference', :mass => 1, :length => 2, :electric_current => -1, :time => -3
  config.load :physical_quantity => 'electric resistance', :mass => 1, :length => 2, :electric_current => -2, :time => -3
  config.load :physical_quantity => 'electrical capacitance', :electric_current => 2, :time => 4, :mass => -1, :length => -2
  config.load :physical_quantity => 'energy', :mass => 1, :length => 2, :time => -2
  config.load :physical_quantity => 'entropy', :length => 2, :mass => 1, :time => -2, :temperature => -1
  config.load :physical_quantity => 'force', :length => 1, :mass => 1, :time => -2
  config.load :physical_quantity => 'frequency', :time => -1
  config.load :physical_quantity => 'heat capacity', :length => 2, :mass => 1, :time => -2, :temperature => -1
  config.load :physical_quantity => 'illuminance', :luminous_intensity => 1, :length => -2
  config.load :physical_quantity => 'impedance', :length => 2, :mass => 1, :time => -3, :electric_current => -2
  config.load :physical_quantity => 'inductance', :mass => 1, :length => 2, :time => -2, :electric_current => -2
  config.load :physical_quantity => 'irradiance', :mass => 1, :time => -3
  config.load :physical_quantity => 'luminous flux', :luminous_intensity => 1
  config.load :physical_quantity => 'magnetic field strength', :length => -1, :electric_current => 1
  config.load :physical_quantity => 'magnetic flux', :mass => 1, :length => 2, :time => -2, :electric_current => -1
  config.load :physical_quantity => 'magnetic flux density', :mass => 1, :electric_current => -1, :time => -2
  config.load :physical_quantity => 'magnetic dipole moment', :length => 2, :electric_current => 1
  config.load :physical_quantity => 'magnetic vector potential', :mass => 1, :length => 1, :time => -2, :electric_current => -1
  config.load :physical_quantity => 'magnetisation', :length => -1, :electric_current => 1
  config.load :physical_quantity => 'moment of inertia', :length => 2, :mass => 1
  config.load :physical_quantity => 'momentum', :length => 1, :mass => 1, :time => -1
  config.load :physical_quantity => 'number density', :item => 1, :length => -3
  config.load :physical_quantity => 'permeability', :mass => 1, :length => 1, :time => -2, :electric_current => -2
  config.load :physical_quantity => 'permittivity', :mass => -1, :length => -3, :time => 4, :electric_current => 2
  config.load :physical_quantity => 'plane angle' # length / length = dimensionsless
  config.load :physical_quantity => 'power', :mass => 1, :length => 2, :time => -3
  config.load :physical_quantity => 'pressure', :mass => 1, :length => -1, :time => -2
  config.load :physical_quantity => 'radiation absorbed dose', :length => 2, :time => -2
  config.load :physical_quantity => 'radiation dose equivalent', :length => 2, :time => -2
  config.load :physical_quantity => 'radioactivity', :time => -1
  config.load :physical_quantity => 'solid angle' # area / area = dimensionless
  config.load :physical_quantity => 'surface tension', :mass => 1, :time => -2
  config.load :physical_quantity => 'velocity', :length => 1, :time => -1
  config.load :physical_quantity => 'dynamic viscosity', :length => -1, :mass => 1, :time => -1
  config.load :physical_quantity => 'kinematic viscosity', :length => 2, :time => -1
  config.load :physical_quantity => 'volume', :length => 3
  config.load :physical_quantity => 'energy density', :length => -1, :mass => 1, :time => -2
  config.load :physical_quantity => 'thermal resistance', :temperature => 1, :mass => -1, :time => 3
  config.load :physical_quantity => 'catalytic activity', :amount_of_substance => 1, :time => -1

end

Prefix::SI.configure do |config|

  # SI prefixes
  config.load :name => 'deca', :symbol => 'da', :factor => 1e1
  config.load :name => 'hecto', :symbol => 'h', :factor => 1e2
  config.load :name => 'kilo', :symbol => 'k', :factor => 1e3
  config.load :name => 'mega', :symbol => 'M', :factor => 1e6
  config.load :name => 'giga', :symbol => 'G', :factor => 1e9
  config.load :name => 'tera', :symbol => 'T', :factor => 1e12
  config.load :name => 'peta', :symbol => 'P', :factor => 1e15
  config.load :name => 'exa', :symbol => 'E', :factor => 1e18
  config.load :name => 'zetta', :symbol => 'Z', :factor => 1e21
  config.load :name => 'yotta', :symbol => 'Y', :factor => 1e24
  config.load :name => 'deci', :symbol => 'd', :factor => 1e-1
  config.load :name => 'centi', :symbol => 'c', :factor => 1e-2
  config.load :name => 'milli', :symbol => 'm', :factor => 1e-3
  config.load :name => 'micro', :symbol => 'μ', :factor => 1e-6
  config.load :name => 'nano', :symbol => 'n', :factor => 1e-9
  config.load :name => 'pico', :symbol => 'p', :factor => 1e-12
  config.load :name => 'femto', :symbol => 'f', :factor => 1e-15
  config.load :name => 'atto', :symbol => 'a', :factor => 1e-18
  config.load :name => 'zepto', :symbol => 'z', :factor => 1e-21
  config.load :name => 'yocto', :symbol => 'y', :factor => 1e-24

end

Prefix::NonSI.configure do |config|

  # This prefix is used to represent 1 million British Thermal Units. It
  # derives from the 'M' prefix which is used to represent 1 thousand (and is
  # presumably based on Roman numerals). The latter prefix is not defined here
  # since it conflicts directly with the SI prefix for 1 million (mega; M).
  #
  # The 'MM' prefix is considered bad practice, but is nevertheless commonly
  # used in the US, so is added here to provide this support.
  config.load :name => 'million', :symbol => 'MM', :factor => 1e6

end

Unit::SI.configure do |config|

  # Load SI units.
  #
  # Conversion factors between units are specified relative to the standard -
  # SI - units and therefore these implicitly represent a factor of 1.
  #
  # This is initialized by default in the Unit class and therefore does not
  # need to be declared here.
  #
  # SI units therefore require only their physical quantity to be specified.
  config.load :name => 'ampere', :physical_quantity => 'electric_current', :symbol => 'A', :label => 'A'
  # config.load :name => 'amagat', :physical_quantity => 'number_density', :symbol => 'η'
  config.load :name => 'bit', :physical_quantity => 'information', :symbol => 'bit', :label => 'bit'
  config.load :name => 'bequerel', :physical_quantity => 'radioactivity', :symbol => 'Bq', :label => 'Bq'
  config.load :name => 'candela', :physical_quantity => 'luminous_intensity', :symbol => 'cd', :label => 'cd', :acts_as_surrogate => true
  config.load :name => 'coloumb', :physical_quantity => 'electric_charge', :symbol => 'C', :label => 'C'
  config.load :name => 'cubic metre', :physical_quantity => 'volume', :symbol => 'm^3', :label => 'm^3'
  config.load :name => 'farad', :physical_quantity => 'electrical_capacitance', :symbol => 'F', :label => 'F'
  config.load :name => 'gray', :physical_quantity => 'radiation_absorbed_dose', :symbol => 'Gy', :label => 'Gy'
  config.load :name => 'hertz', :physical_quantity => 'frequency', :symbol => 'Hz', :label => 'Hz', :acts_as_surrogate => true
  config.load :name => 'henry', :physical_quantity => 'inductance', :symbol => 'H', :label => 'H'
  config.load :name => 'joule', :physical_quantity => 'energy', :symbol => 'J', :label => 'J', :acts_as_surrogate => true
  config.load :name => 'katal', :physical_quantity => 'catalytic activity', :symbol => 'kat', :label => 'kat'
  config.load :name => 'kelvin', :physical_quantity => 'temperature', :symbol => 'K', :label => 'K', :acts_as_surrogate => true
  config.load :name => 'lumen', :physical_quantity => 'luminous_flux', :symbol => 'lm', :label => 'lm'
  config.load :name => 'lux', :physical_quantity => 'illuminance', :symbol => 'lx', :label => 'lx'
  config.load :name => 'metre', :physical_quantity => 'length', :symbol => 'm', :label => 'm', :acts_as_surrogate => true
  config.load :name => 'metre per second', :physical_quantity => 'velocity', :symbol => 'm s^-1', :label => 'm/s'
  config.load :name => 'metre per square second', :physical_quantity => 'acceleration', :symbol => 'm s^-2', :label => 'm/s^2'
  config.load :name => 'mole', :physical_quantity => 'amount_of_substance', :symbol => 'mol', :label => 'mol', :acts_as_surrogate => true
  config.load :name => 'newton', :physical_quantity => 'force', :symbol => 'N', :label => 'N', :acts_as_surrogate => true
  config.load :name => 'ohm', :physical_quantity => 'electric_resistance', :symbol => 'Ω', :label => 'Ohm'
  config.load :name => 'pascal', :physical_quantity => 'pressure', :symbol => 'Pa', :label => 'Pa'
  config.load :name => 'radian', :physical_quantity => 'plane_angle', :symbol => 'rad', :label => 'rad'
  config.load :name => 'second', :physical_quantity => 'time', :symbol => 's', :label => 's', :acts_as_surrogate => true
  config.load :name => 'siemens', :physical_quantity => 'electric_conductance', :symbol => 'S', :label => 'S'
  config.load :name => 'sievert', :physical_quantity => 'radiation_dose_equivalent', :symbol => 'Sv', :label => 'Sv'
  config.load :name => 'steridian', :physical_quantity => 'solid_angle', :symbol => 'sr', :label => 'sr'
  config.load :name => 'square metre', :physical_quantity => 'area', :symbol => 'm^2', :label => 'm^2'
  config.load :name => 'tesla', :physical_quantity => 'magnetic_flux_density', :symbol => 'T', :label => 'T'
  config.load :name => 'volt', :physical_quantity => 'electric_potential_difference', :symbol => 'V', :label => 'V'
  config.load :name => 'watt', :physical_quantity => 'power', :symbol => 'W', :label => 'W', :acts_as_surrogate => true
  config.load :name => 'weber', :physical_quantity => 'magnetic_flux', :symbol => 'Wb', :label => 'Wb'

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
  config.load :name => 'kilogram', :physical_quantity => :mass, :symbol => 'kg', :label => 'kg'
  config.load :name => 'gram', :physical_quantity => 'mass', :factor => 1e-3, :symbol => 'g', :label => 'g'

  # add required prefixes individually
  Unit.micrometre.load

  Unit.centiradian.load do |unit|
    unit.label = 'centiradian'
  end

  # Or ... add required prefixes on a multiple basis
  #
  # Should write some class methods for making mass specification of SI units 
  # and prefixes easier
  #
  [:kilo,:mega,:giga,:tera].map do |prefix|
    Unit.si_units.map do |unit|
      unit.with_prefix(prefix) unless unit.name == 'kilogram' 
    end
  end.flatten.compact.each {|unit| unit.load }

  [:mega,:giga,:tera].map do |prefix|
    Unit.g.with_prefix(prefix).load
  end

end

Unit::NonSI.configure do |config|

  # Non-SI units. These units are measures of quantities which do not conform
  # to the SI system. They are therefore represent by a conversion factor which
  # is defined relative to the corresponding SI unit for that quantity.
  #
  # config.load :name => 'acre', :physical_quantity => 'area', :factor => 4046.8564224
  # config.load :name => 'abampere', :physical_quantity => 'electric current', :factor => 10.0, :symbol => 'abA'
  # config.load :name => 'abcoloumb', :physical_quantity => 'electric charge', :factor => 10.0, :symbol => 'abC'
  # config.load :name => 'abfarad', :physical_quantity => 'electrical capacitance', :factor => 1e9
  # config.load :name => 'abhenry', :physical_quantity => 'inductance', :factor => 1e-9
  # config.load :name => 'abhmo', :physical_quantity => 'electric conductance', :factor => 1e9
  # config.load :name => 'abohm', :physical_quantity => 'electric resistance', :factor => 1e-9
  # config.load :name => 'abvolt', :physical_quantity => 'electric potential_difference', :factor => 10e-9, :symbol => 'abV'
  config.load :name => 'angstrom', :physical_quantity => 'length', :factor => 100e-12, :symbol => 'Å', :label => 'Å'
  config.load :name => 'arcminute', :physical_quantity => 'plane angle', :factor => Math::PI/10800, :symbol => '′', :label => '′'
  config.load :name => 'arcsecond', :physical_quantity => 'plane angle', :factor => Math::PI/648000, :symbol => '″', :label => '″'
  config.load :name => 'are', :physical_quantity => 'area', :factor => 100.0, :symbol => 'a', :label => 'a'
  config.load :name => 'astronomical unit', :physical_quantity => 'length', :factor => 149.5979e9, :symbol => 'AU', :label => 'ua'
  config.load :name => 'atmosphere', :physical_quantity => 'pressure', :factor => 101.325e3, :symbol => 'atm', :label => 'atm'
  config.load :name => 'bar', :physical_quantity => 'pressure', :factor => 100e3, :symbol => 'bar', :label => 'bar'
  # config.load :name => 'barn', :physical_quantity => 'area', :factor => 100e-30, :symbol => 'b'
  # config.load :name => 'baromil', :physical_quantity => 'length', :factor => 750.1e-6
  # config.load :name => 'petroleum barrel', :physical_quantity => 'volume', :factor => 158.9873e-3, :symbol => 'bbl'
  # config.load :name => 'uk barrel', :physical_quantity => 'volume', :factor => 163.6592e-3, :symbol => 'bl (Imp)'
  # config.load :name => 'us dry barrel', :physical_quantity => 'volume', :factor => 115.6271e-3, :symbol => 'bl (US)'
  # config.load :name => 'us liquid barrel', :physical_quantity => 'volume', :factor => 119.2405e-3, :symbol => 'fl bl (US)'
  # config.load :name => 'biot', :physical_quantity => 'electric current', :factor => 10.0, :symbol => 'Bi'
  config.load :name => 'british thermal unit (59 °F)', :physical_quantity => 'energy', :factor => 1054.804, :symbol => 'BTU', :label => 'BTU_FiftyNineF'
  # The IT (International [Steam] Table) defined BTU is apparently the most widely used so is given the basic name here
  config.load :name => 'british thermal unit', :physical_quantity => 'energy', :factor => 1055.05585262, :symbol => 'BTU', :label => 'BTU_IT'
  config.load :name => 'british thermal unit (39 °F)', :physical_quantity => 'energy', :factor => 1059.67, :symbol => 'BTU', :label => 'BTU_ThirtyNineF'
  config.load :name => 'british thermal unit (mean)', :physical_quantity => 'energy', :factor => 1055.87, :symbol => 'BTU', :label => 'BTU_Mean'
  config.load :name => 'british thermal unit (ISO)', :physical_quantity => 'energy', :factor => 1055.056, :symbol => 'BTU', :label => 'BTU_ISO'
  config.load :name => 'british thermal unit (60 °F)', :physical_quantity => 'energy', :factor => 1054.68, :symbol => 'BTU', :label => 'BTU_SixtyF'
  config.load :name => 'british thermal unit (63 °F)', :physical_quantity => 'energy', :factor => 1054.6, :symbol => 'BTU', :label => 'BTU_SixtyThreeF'
  config.load :name => 'british thermal unit (thermochemical)', :physical_quantity => 'energy', :factor => 1054.35026444, :symbol => 'BTU', :label => 'BTU_Thermochemical'
  # config.load :name => 'bushel_uk', :physical_quantity => 'volume', :factor => 36.36872e-3, :symbol => 'bu (Imp)'
  # config.load :name => 'bushel_us', :physical_quantity => 'volume', :factor => 35.23907e-3, :symbol => 'bu (US lvl)'
  # config.load :name => 'butt', :physical_quantity => 'volume', :factor => 477.3394e-3
  config.load :name => 'byte', :physical_quantity => 'information', :factor => 8, :symbol => 'byte', :label => 'byte'
  # config.load :name => 'cable', :physical_quantity => 'length', :factor => 219.456
  # config.load :name => 'calorie', :physical_quantity => 'energy', :factor => 4.1868, :symbol => 'cal'
  # config.load :name => 'candle power', :physical_quantity => 'luminous flux', :factor => 4*Math::PI, :symbol => 'cp'
  # config.load :name => 'carat', :physical_quantity => 'mass', :factor => 200e-6, :symbol => 'kt'
  # config.load :name => 'celsius heat unit', :physical_quantity => 'energy', :factor => 1.0899101e3, :symbol => 'CHU'
  # config.load :name => 'centimetre of mercury', :physical_quantity => 'pressure', :factor => 1.333222e3, :symbol => 'cmHg'
  # config.load :name => 'centimetre of water', :physical_quantity => 'pressure', :factor => 98.060616, :symbol => 'cmH2O'
  # config.load :name => 'chain', :physical_quantity => 'length', :factor => 20.1168, :symbol => 'ch'
  # config.load :name => 'us cup', :physical_quantity => 'volume', :factor => 236.5882e-6, :symbol => 'c (US)'
  config.load :name => 'curie', :physical_quantity => 'radioactivity', :factor => 37.0e9, :symbol => 'Ci', :label => 'Ci'
  config.load :name => 'day', :physical_quantity => 'time', :factor => 86.4e3, :symbol => 'd', :label => 'd'
  config.load :name => 'sidereal day', :physical_quantity => 'time', :factor => 86.16409053e3, :symbol => 'd', :label => 'day_sidereal'
  config.load :name => 'degree', :physical_quantity => 'plane angle', :factor => Math::PI/180.0, :symbol => '°', :label => '°'
  config.load :name => 'degree celsius', :physical_quantity => 'temperature', :scaling => 273.15, :symbol => '°C', :label => '°C'
  config.load :name => 'degree farenheit', :physical_quantity => 'temperature', :factor => 5.0/9.0, :scaling => 459.67, :symbol => '°F', :label => '°F'
  config.load :name => 'degree rankine', :physical_quantity => 'temperature', :factor => 5.0/9.0, :symbol => '°R', :label => '°R'
  # config.load :name => 'dram', :physical_quantity => 'length', :factor => 1.771845e-3, :symbol => 'dr av'
  config.load :name => 'dyne', :physical_quantity => 'force', :factor => 10e-6, :symbol => 'dyn', :label => 'dyn'
  # config.load :name => 'dyne centimetre', :physical_quantity => 'energy', :factor => 100e-9, :symbol => 'dyn cm'
  config.load :name => 'electron mass', :physical_quantity => 'mass', :factor => 9.10938188e-31, :symbol => 'me', :label => 'me'
  config.load :name => 'electron volt', :physical_quantity => 'energy', :factor => 160.218e-21, :symbol => 'eV', :label => 'eV'
  config.load :name => 'erg', :physical_quantity => 'energy', :factor => 100.0e-9, :symbol => 'erg', :label => 'erg'
  # config.load :name => 'ell', :physical_quantity => 'length', :factor => 1.143, :symbol => 'ell'
  config.load :name => 'faraday', :physical_quantity => 'electric charge', :factor => 96.4853e3, :symbol => 'F', :label => 'Fd'
  # config.load :name => 'fathom', :physical_quantity => 'length', :factor => 1.828804, :symbol => 'fm'
  # config.load :name => 'fermi', :physical_quantity => 'length', :factor => 1e-15, :symbol => 'fm'
  config.load :name => 'uk fluid ounce', :physical_quantity => 'volume', :factor => 28.41308e-6, :symbol => 'fl oz', :label => 'oz_fl_uk'
  config.load :name => 'us fluid ounce', :physical_quantity => 'volume', :factor => 29.57353e-6, :symbol => 'fl oz', :label => 'oz_fl'
  config.load :name => 'foot', :physical_quantity => 'length', :factor => 0.3048, :symbol => 'ft', :label => 'ft'
  config.load :name => 'us survey foot', :physical_quantity => 'length', :factor => 304.8e-3, :symbol => 'ft', :label => 'foot_survey_us'
  config.load :name => 'franklin', :physical_quantity => 'electric charge', :factor => 3.3356e-10, :symbol => 'Fr', :label => 'Fr'
  # config.load :name => 'foot of water', :physical_quantity => 'pressure', :factor => 2.988887e3, :symbol => 'ftH2O'
  # config.load :name => 'footcandle', :physical_quantity => :illuminance, :factor => 10.76391, :symbol => 'fc'
  # config.load :name => 'furlong', :physical_quantity => :length, :factor => 201.168, :symbol => 'fur'
  config.load :name => 'uk gallon', :physical_quantity => 'volume', :factor => 4.546092, :symbol => 'gal', :label => 'gal_uk'
  config.load :name => 'us liquid gallon', :physical_quantity => 'volume', :factor => 3.785412, :symbol => 'gal', :label => 'gal'
  config.load :name => 'us dry gallon', :physical_quantity => 'volume', :factor => 0.00440488377086, :symbol => 'gal', :label => 'gallon_dry_us'
  # config.load :name => 'gamma', :physical_quantity => 'magnetic flux density', :factor => 1e-9, :symbol => 'γ'
  config.load :name => 'gauss', :physical_quantity => 'magnetic flux density', :factor => 100e-6, :symbol => 'G', :label => 'G'
  # config.load :name => 'uk gill', :physical_quantity => 'volume', :factor => 142.0654e-6, :symbol => 'gi'
  # config.load :name => 'us gill', :physical_quantity => 'volume', :factor => 118.2941e-6, :symbol => 'gi'
  config.load :name => 'grad', :physical_quantity => 'plane_angle', :factor => Math::PI/200.0, :symbol => 'grad', :label => 'grade'
  # config.load :name => 'grain', :physical_quantity => 'mass', :factor => 64.79891e-6, :symbol => 'gr'
  # config.load :name => 'hartree', :physical_quantity => 'energy', :factor => 4.359748e-18, :symbol => 'Eh'
  config.load :name => 'hectare', :physical_quantity => 'area', :factor => 10e3, :symbol => 'ha', :label => 'ha'
  # config.load :name => 'hogshead', :physical_quantity => 'volume', :factor => 238.6697e-3, :symbol => 'hhd'
  # config.load :name => 'boiler horsepower', :physical_quantity => 'power', :factor => 9.80950e3, :symbol => 'bhp'
  # config.load :name => 'electric horsepower', :physical_quantity => 'power', :factor => 746.0, :symbol => 'hp'
  config.load :name => 'metric horsepower', :physical_quantity => 'power', :factor => 735.4988, :symbol => 'hp', :label => 'hp'
  # config.load :name => 'uk horsepower', :physical_quantity => 'power', :factor => 745.6999, :symbol => 'hp'
  config.load :name => 'hour', :physical_quantity => 'time', :factor => 3.6e3, :symbol => 'h', :label => 'h'
  # config.load :name => 'hundredweight long', :physical_quantity => 'mass', :factor => 50.802345, :symbol => 'cwt'
  # config.load :name => 'hundredweight short', :physical_quantity => 'mass', :factor => 45.359237, :symbol => 'cwt'
  config.load :name => 'inch', :physical_quantity => 'length', :factor => 25.4e-3, :symbol => 'in', :label => 'in'
  config.load :name => 'inch of mercury', :physical_quantity => 'pressure', :factor => 3.386389e3, :symbol => 'inHg', :label => 'inHg'
  # config.load :name => 'inch of water', :physical_quantity => 'pressure', :factor => 249.0740, :symbol => 'inH2O'
  # config.load :name => 'kilocalorie', :physical_quantity => 'energy', :factor => 4.1868e3, :symbol => 'kcal'
  config.load :name => 'kilowatt hour', :physical_quantity => 'energy', :factor => 3.6e6, :symbol => 'kW h', :label => 'kWh'
  config.load :name => 'kilogram force', :physical_quantity => 'force', :factor => 9.80665, :symbol => 'kgf', :label => 'kgf'
  config.load :name => 'knot', :physical_quantity => 'velocity', :factor => 514.4444e-3, :symbol => 'kn', :label => 'kn'
  config.load :name => 'lambert', :physical_quantity => 'illuminance', :factor => 1e4, :symbol => 'La', :label => 'La'
  # config.load :name => 'nautical league', :physical_quantity => 'length', :factor => 5.556e3, :symbol => 'nl'
  # config.load :name => 'statute league', :physical_quantity => 'length', :factor => 4.828032e3, :symbol => 'lea'
  config.load :name => 'light year', :physical_quantity => 'length', :factor => 9.46073e15, :symbol => 'ly', :label => 'ly'
  # config.load :name => 'line', :physical_quantity => 'length', :factor => 2.116667e-3, :symbol => 'ln'
  # config.load :name => 'link', :physical_quantity => 'length', :factor => 201.168e-3, :symbol => 'lnk'
  config.load :name => 'litre', :physical_quantity => 'volume', :factor => 1e-3, :symbol => 'L', :label => 'L'
  config.load :name => 'maxwell', :physical_quantity => 'magnetic flux', :factor => 10e-9, :symbol => 'Mx', :label => 'Mx'
  # config.load :name => 'micron', :physical_quantity => 'length', :factor => 1e-6, :symbol => 'μm'
  config.load :name => 'minute', :physical_quantity => 'time', :factor => 60.0, :symbol => 'min', :label => 'min'
  config.load :name => 'mile', :physical_quantity => 'length', :factor => 1.609344e3, :symbol => 'mi', :label => 'mi'
  config.load :name => 'nautical mile', :physical_quantity => 'length', :factor => 1.852e3, :symbol => 'nmi', :label => 'nmi'
  # config.load :name => 'millibar', :physical_quantity => 'pressure', :factor => 100, :symbol => 'mbar'
  config.load :name => 'millimetre of mercury', :physical_quantity => 'pressure', :factor => 1.333222e2, :symbol => 'mmHg', :label => 'mmHg'
  config.load :name => 'month', :physical_quantity => 'time', :factor => 2.551444e6, :symbol => 'month', :label => 'month'
  config.load :name => 'ounce', :physical_quantity => 'mass', :factor => 28.34952e-3, :symbol => 'oz', :label => 'oz'
  config.load :name => 'point', :physical_quantity => 'length', :factor => 351.4598e-6, :symbol => 'pt', :label => 'pt'
  config.load :name => 'pound', :physical_quantity => 'mass', :factor => 0.45359237, :symbol => 'lb', :label => 'lb'
  config.load :name => 'parsec', :physical_quantity => 'length', :factor => 30.85678e15, :symbol => 'pc', :label => 'pc'
  # config.load :name => 'pennyweight', :physical_quantity => 'mass', :factor => 1.555174e-3, :symbol => 'dwt'
  # config.load :name => 'poncelot', :physical_quantity => 'power', :factor => 980.665, :symbol => 'p'
  # config.load :name => 'poundal', :physical_quantity => 'force', :factor => 138.255, :symbol => 'pdl'
  config.load :name => 'pound force', :physical_quantity => 'force', :factor => 4.448222, :symbol => 'lbf', :label => 'lbf'
  # config.load :name => 'quad', :physical_quantity => 'energy', :factor => 1.055056e18, :symbol => 'quad'
  config.load :name => 'rad', :physical_quantity => 'radiation absorbed dose', :factor => 0.01, :symbol => 'rad', :label => 'rd'
  config.load :name => 'revolution', :physical_quantity => 'plane angle', :factor => 2*Math::PI, :symbol => 'rev', :label => 'rev'
  # config.load :name => 'reyn', :physical_quantity => 'dynamic viscosity', :factor => 689.5e3, :symbol => 'reyn'
  config.load :name => 'rem', :physical_quantity => 'radiation_dose_equivalent', :factor => 0.01, :symbol => 'rem', :label => 'rem'
  # config.load :name => 'rood', :physical_quantity => 'area', :factor => 1.011714e3, :symbol => 'rood'
  config.load :name => 'rutherford', :physical_quantity => 'radioactivity', :factor => 1e6, :symbol => 'rd', :label => 'Rd'
  # config.load :name => 'rydberg', :physical_quantity => 'energy', :factor => 2.179874e-18, :symbol => 'Ry'
  config.load :name => 'sphere', :physical_quantity => 'solid angle', :factor => 4*Math::PI, :label => 'sphere'
  # config.load :name => 'sthene', :physical_quantity => 'force', :factor => 1e3, :symbol => 'sn'
  # config.load :name => 'stokes', :physical_quantity => 'kinematic viscosity', :factor => 100e-6, :symbol => 'St'
  # config.load :name => 'stone', :physical_quantity => 'mass', :factor => 6.350293, :symbol => 'st'
  # config.load :name => 'therm', :physical_quantity => 'energy', :factor => 105.506e6, :symbol => 'thm'
  # config.load :name => 'thermie', :physical_quantity => 'energy', :factor => 4.185407e6, :symbol => 'th'
  config.load :name => 'short ton', :physical_quantity => 'mass', :factor => 907.1847, :symbol => 'ton', :label => 'ton_us'
  config.load :name => 'long ton', :physical_quantity => 'mass', :factor => 1.016047, :symbol => 'ton', :label => 'ton_uk'
  config.load :name => 'tonne', :physical_quantity => 'mass', :factor => 1000.0, :symbol => 't', :label => 't'
  config.load :name => 'unified atomic mass', :physical_quantity => 'mass', :factor => 1.66054e-27, :symbol => 'u', :label => 'u'
  config.load :name => 'week', :physical_quantity => 'time', :factor => 604800, :label => 'week'
  config.load :name => 'yard', :physical_quantity => 'length', :factor => 0.9144, :symbol => 'yd', :label => 'yd'
  config.load :name => 'year', :physical_quantity => 'time', :factor => 31557600, :symbol => 'yr', :label => 'year'
  config.load :name => 'sidereal year', :physical_quantity => 'time', :factor => 31558823.803728, :symbol => 'yr', :label => 'year_sidereal'
  # config.load :name => 'tog', :physical_quantity => 'thermal resistance', :factor => 0.1, :symbol => 'tog'
  # config.load :name => 'clo', :physical_quantity => 'thermal resistance', :factor => 0.155, :symbol => 'clo'


end

Unit::Base.configure do |config|

  # Define a unit representing the quantity 1.
  # This can be used to define reciprocal units using division, i.e.
  #
  #   kg^-1   is equivalent to   1/kg   or   <unity>/<kg>
  #
  config.load :name => 'unity', :physical_quantity => 'dimensionless', :symbol => '1'

  config.load :name => 'percent', :physical_quantity => 'dimensionless', :symbol => '%'

end

Unit::Compound.configure do |config|

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
  (Unit.kg / Unit.kWh).load

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