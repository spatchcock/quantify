# encoding: UTF-8
include Quantify

# Configure known dimensions, prefixes and units.
# Order must be maintained for initialization of all objects to be successful:
#
#  * dimensions,
#  * prefixes,
#  * units.
#
# A basic collection of

Dimensions.configure do

  # Load the standard, widely-recognised physical quantities.

  # Base quantities
  load :physical_quantity => 'length',              :length => 1

  load :physical_quantity => 'mass',                :mass => 1
  
  load :physical_quantity => 'time',                :time => 1
  
  load :physical_quantity => 'electric current',    :electric_current => 1
  
  load :physical_quantity => 'temperature',         :temperature => 1
  
  load :physical_quantity => 'luminous intensity',  :luminous_intensity => 1
  
  load :physical_quantity => 'amount of substance', :amount_of_substance => 1
  
  load :physical_quantity => 'information',         :information => 1
  
  load :physical_quantity => 'currency',            :currency => 1
  
  load :physical_quantity => 'item',                :item => 1
  
  load :physical_quantity => 'dimensionless'

  # Derived quantities
  load :physical_quantity => 'acceleration',                  :length => 1,               :time => -2
  
  load :physical_quantity => 'area',                          :length => 2
  
  load :physical_quantity => 'action',                        :length => 2,  :mass => 1,  :time => -1
  
  load :physical_quantity => 'angular monentum',              :length => 2,  :mass => 1,  :time => -1
  
  load :physical_quantity => 'conductivity',                  :length => -3, :mass => -1, :time => 3,  :electric_current => 2
  
  load :physical_quantity => 'density',                       :length => -3, :mass => 1
  
  load :physical_quantity => 'electric charge',                                           :time => 1,  :electric_current => 1
  
  load :physical_quantity => 'electric charge_density',       :length => -3,              :time => 1,  :electric_current => 1
  
  load :physical_quantity => 'electric conductance',          :length => -2, :mass => -1, :time => 3,  :electric_current => 2
  
  load :physical_quantity => 'electric displacement',         :length => -2,              :time => 1,  :electric_current => 1
  
  load :physical_quantity => 'electric field strength',       :length => 1,  :mass => 1,  :time => -3, :electric_current => -1
  
  load :physical_quantity => 'electric polarisability',                      :mass => -1, :time => 4,  :electric_current => 2
  
  load :physical_quantity => 'electric polarisation',         :length => -2,              :time => 1,  :electric_current => 1
  
  load :physical_quantity => 'electric potential difference', :length => 2,  :mass => 1,  :time => -3, :electric_current => -1
  
  load :physical_quantity => 'electric resistance',           :length => 2,  :mass => 1,  :time => -3, :electric_current => -2
  
  load :physical_quantity => 'electrical capacitance',        :length => -2, :mass => -1, :time => 4,  :electric_current => 2
  
  load :physical_quantity => 'energy',                        :length => 2,  :mass => 1,  :time => -2
  
  load :physical_quantity => 'entropy',                       :length => 2,  :mass => 1,  :time => -2, :temperature => -1
  
  load :physical_quantity => 'force',                         :length => 1,  :mass => 1,  :time => -2
  
  load :physical_quantity => 'frequency',                                                 :time => -1
  
  load :physical_quantity => 'heat capacity',                 :length => 2,  :mass => 1,  :time => -2, :temperature => -1
  
  load :physical_quantity => 'illuminance',                   :length => -2,                           :luminous_intensity => 1
  
  load :physical_quantity => 'impedance',                     :length => 2,  :mass => 1,  :time => -3, :electric_current => -2
  
  load :physical_quantity => 'inductance',                    :length => 2,  :mass => 1,  :time => -2, :electric_current => -2
  
  load :physical_quantity => 'irradiance',                                   :mass => 1,  :time => -3
  
  load :physical_quantity => 'luminous flux',                                                          :luminous_intensity => 1
  
  load :physical_quantity => 'magnetic field strength',       :length => -1,                           :electric_current => 1
  
  load :physical_quantity => 'magnetic flux',                 :length => 2,  :mass => 1,  :time => -2, :electric_current => -1
  
  load :physical_quantity => 'magnetic flux density',                        :mass => 1,  :time => -2, :electric_current => -1
  
  load :physical_quantity => 'magnetic dipole moment',        :length => 2,                            :electric_current => 1
  
  load :physical_quantity => 'magnetic vector potential',     :length => 1,  :mass => 1,  :time => -2, :electric_current => -1
  
  load :physical_quantity => 'magnetisation',                 :length => -1,                           :electric_current => 1
  
  load :physical_quantity => 'moment of inertia',             :length => 2,  :mass => 1
  
  load :physical_quantity => 'momentum',                      :length => 1,  :mass => 1,  :time => -1
  
  load :physical_quantity => 'number density',                :length => -3,                                                                                                  :item => 1
  
  load :physical_quantity => 'permeability',                  :length => 1,  :mass => 1,  :time => -2, :electric_current => -2
  
  load :physical_quantity => 'permittivity',                  :length => -3, :mass => -1, :time => 4,  :electric_current => 2
  
  load :physical_quantity => 'plane angle'                    # length / length = physical_quantityless
  
  load :physical_quantity => 'power',                         :length => 2,  :mass => 1,  :time => -3
  
  load :physical_quantity => 'pressure',                      :length => -1, :mass => 1,  :time => -2
  
  load :physical_quantity => 'radiation absorbed dose',       :length => 2,               :time => -2
  
  load :physical_quantity => 'radiation dose equivalent',     :length => 2,               :time => -2
  
  load :physical_quantity => 'radioactivity',                                             :time => -1
  
  load :physical_quantity => 'solid angle'                    # area / area = dimensionless
  
  load :physical_quantity => 'surface tension',                              :mass => 1,  :time => -2
  
  load :physical_quantity => 'velocity',                      :length => 1,               :time => -1
  
  load :physical_quantity => 'dynamic viscosity',             :length => -1, :mass => 1,  :time => -1
  
  load :physical_quantity => 'kinematic viscosity',           :length => 2,               :time => -1
  
  load :physical_quantity => 'volume',                        :length => 3
  
  load :physical_quantity => 'energy density',                :length => -1, :mass => 1,  :time => -2
  
  load :physical_quantity => 'thermal resistance',                           :mass => -1, :time => 3,  :temperature => 1
  
  load :physical_quantity => 'catalytic activity',                                        :time => -1, :amount_of_substance => 1

end

Unit::Prefix::SI.configure do

  load :name   => 'deca',  
       :symbol => 'da',  
       :factor => 1e1

  load :name   => 'hecto',
       :symbol => 'h',
       :factor => 1e2

  load :name   => 'kilo',
       :symbol => 'k',
       :factor => 1e3

  load :name   => 'mega',
       :symbol => 'M',
       :factor => 1e6

  load :name   => 'giga',
       :symbol => 'G',
       :factor => 1e9

  load :name   => 'tera',
       :symbol => 'T',
       :factor => 1e12

  load :name   => 'peta',
       :symbol => 'P',
       :factor => 1e15

  load :name   => 'exa',
       :symbol => 'E',
       :factor => 1e18

  load :name   => 'zetta',
       :symbol => 'Z',
       :factor => 1e21

  load :name   => 'yotta',
       :symbol => 'Y',
       :factor => 1e24

  load :name   => 'deci',
       :symbol => 'd',
       :factor => 1e-1

  load :name   => 'centi',
       :symbol => 'c',
       :factor => 1e-2

  load :name   => 'milli',
       :symbol => 'm',
       :factor => 1e-3
  
  load :name   => 'micro',
       :symbol => 'μ',
       :factor => 1e-6

  load :name   => 'nano',
       :symbol => 'n',
       :factor => 1e-9

  load :name   => 'pico',
       :symbol => 'p',
       :factor => 1e-12

  load :name   => 'femto',
       :symbol => 'f',
       :factor => 1e-15

  load :name   => 'atto',
       :symbol => 'a',
       :factor => 1e-18

  load :name   => 'zepto',
       :symbol => 'z',
       :factor => 1e-21

  load :name   => 'yocto',
       :symbol => 'y',
       :factor => 1e-24

end

Unit::Prefix::NonSI.configure do

  # The 'MM' prefix is considered bad practice, but is nevertheless commonly
  # used in the US, so could added here to provide this support.
  # 
  # load :name => 'million ', :symbol => 'MM', :factor => 1e6
  # load :name => 'billion ', :symbol => 'B',  :factor => 1e9

end

Unit::Base.configure do

  load :label      => :unity,   
       :name       => '',
       :dimensions => 'dimensionless',
       :symbol     => '', 
       :j_science  => 'unity'

  load :label      => :percent,
       :name       => 'percent',
       :dimensions => 'dimensionless',
       :symbol     => '%',
       :j_science  => '%'

end

Unit::SI.configure do

  # Load SI units.
  #
  # Conversion factors between units are specified relative to the standard -
  # SI - units and therefore these implicitly represent a factor of 1.
  #
  # This is initialized by default in the Unit::Base class and therefore does not
  # need to be declared here. SI units therefore require only their physical quantity
  # to be specified.
  #
  load :label      => :A, 
       :name       => 'ampere',    
       :dimensions => 'electric_current',              
       :symbol     => 'A',   
       :j_science  => 'A'

  load :label      => :η, 
       :name       => 'amagat',    
       :dimensions => 'number_density',
       :symbol     => 'η',   
       :j_science  => 'η'

  load :label      => :bit, 
       :name       => 'bit',
       :dimensions => 'information',                   
       :symbol     => 'bit', 
       :j_science  => 'bit'

  load :label      => :Bq, 
       :name       => 'bequerel',  
       :dimensions => 'radioactivity',                 
       :symbol     => 'Bq',  
       :j_science  => 'Bq'

  load :label      => :cd, 
       :name       => 'candela',
       :dimensions => 'luminous_intensity',
       :symbol     => 'cd', 
       :j_science  => 'cd'

  load :label      => :C, 
       :name       => 'coloumb',   
       :dimensions => 'electric_charge',
       :symbol     => 'C',   
       :j_science  => 'C'

  load :label      => :F, 
       :name       => 'farad',     
       :dimensions => 'electrical_capacitance',        
       :symbol     => 'F',   
       :j_science  => 'F'

  load :label      => :Gy, 
       :name       => 'gray',      
       :dimensions => 'radiation_absorbed_dose',       
       :symbol     => 'Gy',  
       :j_science  => 'Gy'

  load :label      => :Hz, 
       :name       => 'hertz',     
       :dimensions => 'frequency',                     
       :symbol     => 'Hz',  
       :j_science  => 'Hz'

  load :label      => :H, 
       :name       => 'henry',     
       :dimensions => 'inductance',                    
       :symbol     => 'H',   
       :j_science  => 'H'

  load :label      => :J, 
       :name       => 'joule',     
       :dimensions => 'energy',                        
       :symbol     => 'J',   
       :j_science  => 'J'

  load :label      => :kat, 
       :name       => 'katal',     
       :dimensions => 'catalytic activity',            
       :symbol     => 'kat', 
       :j_science  => 'kat'

  load :label      => :K, 
       :name       => 'kelvin',    
       :dimensions => 'temperature',                   
       :symbol     => 'K',   
       :j_science  => 'K'

  load :label      => :lm, 
       :name       => 'lumen',
       :dimensions => 'luminous_flux',
       :symbol     => 'lm',  
       :j_science  => 'lm'

  load :label      => :lx, 
       :name       => 'lux',       
       :dimensions => 'illuminance',                   
       :symbol     => 'lx',  
       :j_science  => 'lx'

  load :label      => :m, 
       :name       => 'metre',     
       :dimensions => 'length',                        
       :symbol     => 'm',   
       :j_science  => 'm'

  load :label      => :mol, 
       :name       => 'mole',      
       :dimensions => 'amount_of_substance',           
       :symbol     => 'mol', 
       :j_science  => 'mol'

  load :label      => :N, 
       :name       => 'newton',    
       :dimensions => 'force',
       :symbol     => 'N',
       :j_science  => 'N'

  load :label      => :Ohm, 
       :name       => 'ohm',
       :dimensions => 'electric_resistance',
       :symbol     => 'Ω',
       :j_science  => 'Ohm'

  load :label      => :Pa,
       :name       => 'pascal',
       :dimensions => 'pressure',
       :symbol     => 'Pa',
       :j_science  => 'Pa'

  load :label      => :rad, 
       :name       => 'radian',
       :dimensions => 'plane_angle',
       :symbol     => 'rad',
       :j_science  => 'rad'

  load :label      => :s,
       :name       => 'second',
       :dimensions => 'time',
       :symbol     => 's',
       :j_science  => 's'

  load :label      => :S, 
       :name       => 'siemens',
       :dimensions => 'electric_conductance',
       :symbol     => 'S',
       :j_science  => 'S'

  load :label      => :Sv, 
       :name       => 'sievert',
       :dimensions => 'radiation_dose_equivalent',
       :symbol     => 'Sv',
       :j_science  => 'Sv'

  load :label      => :sr, 
       :name       => 'steridian',
       :dimensions => 'solid_angle',
       :symbol     => 'sr',
       :j_science  => 'sr'

  load :label      => :T, 
       :name       => 'tesla',
       :dimensions => 'magnetic_flux_density',
       :symbol     => 'T',
       :j_science  => 'T'

  load :label      => :V, 
       :name       => 'volt',
       :dimensions => 'electric_potential_difference',
       :symbol     => 'V',
       :j_science  => 'V'

  load :label      => :W, 
       :name       => 'watt',
       :dimensions => 'power',
       :symbol     => 'W',
       :j_science  => 'W'

  load :label      => :Wb, 
       :name       => 'weber',
       :dimensions => 'magnetic_flux',
       :symbol     => 'Wb',
       :j_science  => 'Wb'

  # The kilogram is unusual in being the SI unit of mass yet containing the
  # 'kilo' prefix.
  #
  # The :gram unit is therefore defined explicitly to act as a base for
  # handling SI prefixes.
  #
  # All mass unit factors are nevertheless specified relative to the SI unit
  # (kilogram), in consistency with all other unit types
  #
  load :label      => :kg, 
       :name       => 'kilogram',
       :dimensions => :mass,
       :symbol     => 'kg',
       :j_science  => 'kg'

  load :label      => :g, 
       :name       => 'gram',
       :dimensions => :mass,
       :symbol     => 'g',
       :j_science  => 'g',
       :factor     => 1e-3

  # Define compound units on the basis of SI units

  (metre**2).load
  
  (metre**3).load
  
  (metre/second).load
  
  (metre/second**2).load

  (1/centimetre).configure do |unit|
    unit.name = 'inverse centimetre'
  end.load

  (centimetre/second**2).configure do |unit|

    unit.name      = 'galileo'
    unit.symbol    = 'Gal'
    unit.label     = 'galileo'
    unit.j_science = 'galileo'
  end.load

  # add required prefixed units individually

  kilometre.load

  micrometre.load do |unit|
    unit.name = 'micron'
  end

  centiradian.load do |unit|
    unit.label     = 'centiradian'
    unit.j_science = 'centiradian'
  end

  # Add required prefixes on a multiple basis.
  # prefix_and_load(:kilo,:metre)
  # prefix_and_load([:kilo,:mega,:giga,:tera],[:metre,:gram,:second])

  # Declare unit which are to act as equivalent units, prevailing over equivalent
  # compound units

  si_base_units.each { |unit| unit.acts_as_equivalent_unit = true }

  joule.acts_as_equivalent_unit = true

  newton.acts_as_equivalent_unit = true

  watt.acts_as_equivalent_unit = true

  pascal.acts_as_equivalent_unit = true

end

Unit::NonSI.configure do

  # Non-SI units. These units are measures of quantities which do not conform
  # to the SI system. They are therefore represent by a conversion factor which
  # is defined relative to the corresponding SI unit for that quantity.

  load :label      => :acre, 
       :name       => 'acre',
       :dimensions => 'area',
       :factor     => 4046.8564224,
       :symbol     => 'acre',
       :j_science  => 'acre'

  load :label      => :angstrom,
       :name       => 'angstrom',
       :dimensions => 'length',
       :factor     => 100e-12,
       :symbol     => 'Å',
       :j_science  => 'Å'

  load :label      => :arc_min, 
       :name       => 'arcminute',
       :dimensions => 'plane angle',
       :factor     => Math::PI/10800,
       :symbol     => '′',
       :j_science  => '′'

  load :label      => :arc_sec, 
       :name       => 'arcsecond',
       :dimensions => 'plane angle',
       :factor     => Math::PI/648000,
       :symbol     => '″',
       :j_science  => '″'

  load :label      => :a, 
       :name       => 'are',
       :dimensions => 'area',
       :factor     => 100.0,
       :symbol     => 'a',
       :j_science  => 'a'

  load :label      => :ua, 
       :name       => 'astronomical unit',
       :dimensions => 'length',
       :factor     => 149.5979e9,
       :symbol     => 'AU',
       :j_science  => 'ua'

  load :label      => :atm, 
       :name       => 'atmosphere',
       :dimensions => 'pressure',
       :factor     => 101.325e3,
       :symbol     => 'atm',
       :j_science  => 'atm'

  load :label      => :bar,
       :name       => 'bar',
       :dimensions => 'pressure',
       :factor     => 100e3,
       :symbol     => 'bar',
       :j_science  => 'bar'

  load :label      => :b, 
       :name       => 'barn',
       :dimensions => 'area',
       :factor     => 100e-30,
       :symbol     => 'b',
       :j_science  => 'b'

  load :label      => :Bi, 
       :name       => 'biot',
       :dimensions => 'electric current',
       :factor     => 10.0,
       :symbol     => 'Bi',
       :j_science  => 'Bi'

  load :label      => :bhp, 
       :name       => 'boiler horsepower',
       :dimensions => 'power',
       :factor     => 9.80950e3,
       :symbol     => 'bhp',
       :j_science  => 'bhp'

  load :label      => :btu_39F, 
       :name       => 'british thermal unit (39 °F)',
       :dimensions => 'energy',
       :factor     => 1059.67,
       :symbol     => 'BTU'

  load :label      => :btu_60f, 
       :name       => 'british thermal unit (60 °F)',
       :dimensions => 'energy',
       :factor     => 1054.68,
       :symbol     => 'BTU'

  load :label      => :btu_63f, 
       :name       => 'british thermal unit (63 °F)',
       :dimensions => 'energy',
       :factor     => 1054.6,
       :symbol     => 'BTU'

  load :label      => :btu_iso, 
       :name       => 'british thermal unit (ISO)',
       :dimensions => 'energy',
       :factor     => 1055.056,
       :symbol     => 'BTU'

  load :label      => :btu_it, 
       :name       => 'british thermal unit (IT)',
       :dimensions => 'energy',
       :factor     => 1055.05585262,
       :symbol     => 'BTU'

  load :label      => :btu_mean, 
       :name       => 'british thermal unit (mean)',
       :dimensions => 'energy',
       :factor     => 1055.87,
       :symbol     => 'BTU'

  load :label      => :btu_thermo, 
       :name       => 'british thermal unit (thermochemical)',
       :dimensions => 'energy',
       :factor     => 1054.35026444,
       :symbol     => 'BTU'

  load :label      => :btu_59f, 
       :name       => 'british thermal unit (59 °F)',
       :dimensions => 'energy',
       :factor     => 1054.804,
       :symbol     => 'BTU'

  load :label      => :bu_imp, 
       :name       => 'US bushel',
       :dimensions => 'volume',
       :factor     => 36.36872e-3,
       :symbol     => 'bu (Imp)',
       :j_science  => 'bu_imp'

  load :label      => :bu_us, 
       :name       => 'UK bushel',
       :dimensions => 'volume',
       :factor     => 35.23907e-3,
       :symbol     => 'bu (US lvl)',
       :j_science  => 'bu_us'

  load :label      => :byte, 
       :name       => 'byte',
       :dimensions => 'information',
       :factor     => 8,
       :symbol     => 'byte',
       :j_science  => 'byte'

  load :label      => :cal, 
       :name       => 'calorie',
       :dimensions => 'energy',
       :factor     => 4.1868,
       :symbol     => 'cal',
       :j_science  => 'cal'

  load :label      => :cp, 
       :name       => 'candle power',
       :dimensions => 'luminous flux',
       :factor     => 4*Math::PI,
       :symbol     => 'cp',
       :j_science  => 'cp'

  load :label      => :kt, 
       :name       => 'carat',
       :dimensions => 'mass',
       :factor     => 200e-6,
       :symbol     => 'kt',
       :j_science  => 'kt'

  load :label      => :CHU, 
       :name       => 'celsius heat unit',
       :dimensions => 'energy',
       :factor     => 1.0899101e3,
       :symbol     => 'CHU',
       :j_science  => 'CHU'

  load :label      => :cmHg, 
       :name       => 'centimetre of mercury',
       :dimensions => 'pressure',
       :factor     => 1.333222e3,
       :symbol     => 'cmHg',
       :j_science  => 'cmHg'

  load :label      => :cmH2O, 
       :name       => 'centimetre of water',
       :dimensions => 'pressure',
       :factor     => 98.060616,
       :symbol     => 'cmH2O',
       :j_science  => 'cmH2O'

  load :label      => :ch, 
       :name       => 'chain',
       :dimensions => 'length',
       :factor     => 20.1168,
       :symbol     => 'ch',
       :j_science  => 'ch'

  load :label      => :clo, 
       :name       => 'clo',
       :dimensions => 'thermal resistance',
       :factor     => 0.155,
       :symbol     => 'clo',
       :j_science  => 'clo'

  load :label      => :c_us, 
       :name       => 'cup',
       :dimensions => 'volume',
       :factor     => 236.5882e-6,
       :symbol     => 'c (US)',
       :j_science  => 'c_us'

  load :label      => :Ci, 
       :name       => 'curie',
       :dimensions => 'radioactivity',
       :factor     => 37.0e9,
       :symbol     => 'Ci',
       :j_science  => 'Ci'

  load :label      => :d, 
       :name       => 'day',
       :dimensions => 'time',
       :factor     => 86.4e3,
       :symbol     => 'd',
       :j_science  => 'd'

  load :label      => :degree, 
       :name       => 'degree',
       :dimensions => 'plane angle',
       :factor     => Math::PI/180.0,
       :symbol     => '°',
       :j_science  => '°'

  load :label      => :deg_c, 
       :name       => 'degree celsius',
       :dimensions => 'temperature',
       :symbol     => '°C',
       :j_science  => '°C',
       :scaling    => 273.15

  load :label      => :deg_f, 
       :name       => 'degree farenheit',
       :dimensions => 'temperature',
       :factor     => 5.0/9.0,
       :symbol     => '°F',
       :j_science  => '°F',
       :scaling    => 459.67

  load :label      => :deg_r, 
       :name       => 'degree rankine',
       :dimensions => 'temperature',
       :factor     => 5.0/9.0,
       :symbol     => '°R',
       :j_science  => '°R'

  load :label      => :dram, 
       :name       => 'dram',
       :dimensions => 'length',
       :factor     => 1.771845e-3,
       :symbol     => 'dram',
       :j_science  => 'dram'

  load :label      => :dyn, 
       :name       => 'dyne',
       :dimensions => 'force',
       :factor     => 10e-6,
       :symbol     => 'dyn',
       :j_science  => 'dyn'

  load :label      => :dyn_cm, 
       :name       => 'dyne centimetre',
       :dimensions => 'energy',
       :factor     => 100e-9,
       :symbol     => 'dyn cm',
       :j_science  => 'dyn_cm'

  load :label      => :hp_elec, 
       :name       => 'electric horsepower',
       :dimensions => 'power',
       :factor     => 746.0,
       :symbol     => 'hp',
       :j_science  => 'hp_elec'

  load :label      => :me, 
       :name       => 'electron mass',
       :dimensions => 'mass',
       :factor     => 9.10938188e-31,
       :symbol     => 'me',
       :j_science  => 'me'

  load :label      => :eV, 
       :name       => 'electron volt',
       :dimensions => 'energy',
       :factor     => 160.218e-21,
       :symbol     => 'eV',
       :j_science  => 'eV'

  load :label      => :ell, 
       :name       => 'ell',
       :dimensions => 'length',
       :factor     => 1.143,
       :symbol     => 'ell',
       :j_science  => 'ell'

  load :label      => :erg, 
       :name       => 'erg',
       :dimensions => 'energy',
       :factor     => 100.0e-9,
       :symbol     => 'erg',
       :j_science  => 'erg'

  load :label      => :Fd, 
       :name       => 'faraday',
       :dimensions => 'electric charge',
       :factor     => 96.4853e3,
       :symbol     => 'F',
       :j_science  => 'Fd'

  load :label      => :ftm, 
       :name       => 'fathom',
       :dimensions => 'length',
       :factor     => 1.828804,
       :symbol     => 'ftm',
       :j_science  => 'ftm'

  load :label      => :fm, 
       :name       => 'fermi',
       :dimensions => 'length',
       :factor     => 1e-15,
       :symbol     => 'fm',
       :j_science  => 'fm'

  load :label      => :ft, 
       :name       => 'foot',
       :dimensions => 'length',
       :factor     => 0.3048,
       :symbol     => 'ft',
       :j_science  => 'ft'

  load :label      => :fc, 
       :name       => 'footcandle',
       :dimensions => 'illuminance',
       :factor     => 10.76391,
       :symbol     => 'fc',
       :j_science  => 'fc'

  load :label      => :ftH2O, 
       :name       => 'foot of water',
       :dimensions => 'pressure',
       :factor     => 2.988887e3,
       :symbol     => 'ftH2O',
       :j_science  => 'ftH2O'

  load :label      => :Fr, 
       :name       => 'franklin',
       :dimensions => 'electric charge',
       :factor     => 3.3356e-10,
       :symbol     => 'Fr',
       :j_science  => 'Fr'

  load :label      => :fur, 
       :name       => 'furlong',
       :dimensions => 'length',
       :factor     => 201.168,
       :symbol     => 'fur',
       :j_science  => 'fur'

  load :label      => :γ, 
       :name       => 'gamma',
       :dimensions => 'magnetic flux density',
       :factor     => 1e-9,
       :symbol     => 'γ',
       :j_science  => 'γ'

  load :label      => :gauss, 
       :name       => 'gauss',
       :dimensions => 'magnetic flux density',
       :factor     => 100e-6,
       :symbol     => 'G',
       :j_science  => 'G'

  load :label      => :grad, 
       :name       => 'grad',
       :dimensions => 'plane_angle',
       :factor     => Math::PI/200.0,
       :symbol     => 'grad',
       :j_science  => 'grade'

  load :label      => :gr, 
       :name       => 'grain',
       :dimensions => 'mass',
       :factor     => 64.79891e-6,
       :symbol     => 'gr',
       :j_science  => 'gr'

  load :label      => :Eh, 
       :name       => 'hartree',
       :dimensions => 'energy',
       :factor     => 4.359748e-18,
       :symbol     => 'Eh',
       :j_science  => 'Eh'

  load :label      => :ha, 
       :name       => 'hectare',
       :dimensions => 'area',
       :factor     => 10e3,
       :symbol     => 'ha',
       :j_science  => 'ha'

  load :label      => :hhd, 
       :name       => 'hogshead',
       :dimensions => 'volume',
       :factor     => 238.6697e-3,
       :symbol     => 'hhd',
       :j_science  => 'hhd'

  load :label      => :h, 
       :name       => 'hour',
       :dimensions => 'time',
       :factor     => 3.6e3,
       :symbol     => 'h',
       :j_science  => 'h'

  load :label      => :cwt_long, 
       :name       => 'hundredweight long',
       :dimensions => 'mass',
       :factor     => 50.802345,
       :symbol     => 'cwt',
       :j_science  => 'cwt_long'

  load :label      => :cwt_short, 
       :name       => 'hundredweight short',
       :dimensions => 'mass',
       :factor     => 45.359237,
       :symbol     => 'cwt',
       :j_science  => 'cwt_short'

  load :label      => :in, 
       :name       => 'inch',
       :dimensions => 'length',
       :factor     => 25.4e-3,
       :symbol     => 'in',
       :j_science  => 'in'

  load :label      => :inHg, 
       :name       => 'inch of mercury',
       :dimensions => 'pressure',
       :factor     => 3.386389e3,
       :symbol     => 'inHg',
       :j_science  => 'inHg'

  load :label      => :inH2O, 
       :name       => 'inch of water',
       :dimensions => 'pressure',
       :factor     => 249.0740,
       :symbol     => 'inH2O',
       :j_science  => 'inH2O'

  load :label      => :kcal, 
       :name       => 'kilocalorie',
       :dimensions => 'energy',
       :factor     => 4.1868e3,
       :symbol     => 'kcal',
       :j_science  => 'kcal'

  load :label      => :kgf, 
       :name       => 'kilogram force',
       :dimensions => 'force',
       :factor     => 9.80665,
       :symbol     => 'kgf',
       :j_science  => 'kgf'

  load :label      => :kn, 
       :name       => 'knot',
       :dimensions => 'velocity',
       :factor     => 514.4444e-3,
       :symbol     => 'kn',
       :j_science  => 'kn'

  load :label      => :La, 
       :name       => 'lambert',
       :dimensions => 'illuminance',
       :factor     => 1e4,
       :symbol     => 'La',
       :j_science  => 'La'

  load :label      => :ly, 
       :name       => 'light year',
       :dimensions => 'length',
       :factor     => 9.46073e15,
       :symbol     => 'ly',
       :j_science  => 'ly'

  load :label      => :ln, 
       :name       => 'line',
       :dimensions => 'length',
       :factor     => 2.116667e-3,
       :symbol     => 'ln',
       :j_science  => 'ln'

  load :label      => :lnk, 
       :name       => 'link',
       :dimensions => 'length',
       :factor     => 201.168e-3,
       :symbol     => 'lnk',
       :j_science  => 'lnk'

  load :label      => :L, 
       :name       => 'litre',
       :dimensions => 'volume',
       :factor     => 1e-3,
       :symbol     => 'L',
       :j_science  => 'L'

  load :label      => :ton_uk, 
       :name       => 'long ton',
       :dimensions => 'mass',
       :factor     => 1.016047e3,
       :symbol     => 'ton',
       :j_science  => 'ton_uk'

  load :label      => :Mx, 
       :name       => 'maxwell',
       :dimensions => 'magnetic flux',
       :factor     => 10e-9,
       :symbol     => 'Mx',
       :j_science  => 'Mx'

  load :label      => :hp, 
       :name       => 'metric horsepower',
       :dimensions => 'power',
       :factor     => 735.4988,
       :symbol     => 'hp',
       :j_science  => 'hp'

  load :label      => :mi, 
       :name       => 'mile',
       :dimensions => 'length',
       :factor     => 1.609344e3,
       :symbol     => 'mi',
       :j_science  => 'mi'

  load :label      => :mbar, 
       :name       => 'millibar',
       :dimensions => 'pressure',
       :factor     => 100,
       :symbol     => 'mbar',
       :j_science  => 'mbar'

  load :label      => :mmHg, 
       :name       => 'millimetre of mercury',
       :dimensions => 'pressure',
       :factor     => 1.333222e2,
       :symbol     => 'mmHg',
       :j_science  => 'mmHg'

  load :label      => :min, 
       :name       => 'minute',
       :dimensions => 'time',
       :factor     => 60.0,
       :symbol     => 'min',
       :j_science  => 'min'

  load :label      => :month, 
       :name       => 'month',
       :dimensions => 'time',
       :factor     => 2.551444e6,
       :symbol     => 'month',
       :j_science  => 'month'

  load :label      => :nl, 
       :name       => 'nautical league',
       :dimensions => 'length',
       :factor     => 5.556e3,
       :symbol     => 'nl',
       :j_science  => 'nl'

  load :label      => :nmi, 
       :name       => 'nautical mile',
       :dimensions => 'length',
       :factor     => 1.852e3,
       :symbol     => 'nmi',
       :j_science  => 'nmi'

  load :label      => :oz, 
       :name       => 'ounce',
       :dimensions => 'mass',
       :factor     => 28.34952e-3,
       :symbol     => 'oz',
       :j_science  => 'oz'

  load :label      => :pc, 
       :name       => 'parsec',
       :dimensions => 'length',
       :factor     => 30.85678e15,
       :symbol     => 'pc',
       :j_science  => 'pc'

  load :label      => :dwt, 
       :name       => 'pennyweight',
       :dimensions => 'mass',
       :factor     => 1.555174e-3,
       :symbol     => 'dwt',
       :j_science  => 'dwt'

  load :label      => :bbl, 
       :name       => 'petroleum barrel',
       :dimensions => 'volume',
       :factor     => 158.9873e-3,
       :symbol     => 'bbl',
       :j_science  => 'bbl'

  load :label      => :pt, 
       :name       => 'point',
       :dimensions => 'length',
       :factor     => 351.4598e-6,
       :symbol     => 'pt',
       :j_science  => 'pt'

  load :label      => :p, 
       :name       => 'poncelot',
       :dimensions => 'power',
       :factor     => 980.665,
       :symbol     => 'p',
       :j_science  => 'p'

  load :label      => :lb, 
       :name       => 'pound',
       :dimensions => 'mass',
       :factor     => 0.45359237,
       :symbol     => 'lb',
       :j_science  => 'lb'

  load :label      => :pdl, 
       :name       => 'poundal',
       :dimensions => 'force',
       :factor     => 138.255,
       :symbol     => 'pdl',
       :j_science  => 'pdl'

  load :label      => :lbf, 
       :name       => 'pound force',
       :dimensions => 'force',
       :factor     => 4.448222,
       :symbol     => 'lbf',
       :j_science  => 'lbf'

  load :label      => :lbmol, 
       :name       => 'pound mole',
       :dimensions => 'amount_of_substance',
       :factor     => 453.59237,
       :symbol     => 'lbmol',
       :j_science  => 'lbmol'

  load :label      => :quad, 
       :name       => 'quad',
       :dimensions => 'energy',
       :factor     => 1.055056e18,
       :symbol     => 'quad',
       :j_science  => 'quad'

  load :label      => :rd, 
       :name       => 'rad',
       :dimensions => 'radiation absorbed dose',
       :factor     => 0.01,
       :symbol     => 'rad',
       :j_science  => 'rd'

  load :label      => :rem, 
       :name       => 'rem',
       :dimensions => 'radiation_dose_equivalent',
       :factor     => 0.01,
       :symbol     => 'rem',
       :j_science  => 'rem'

  load :label      => :rev, 
       :name       => 'revolution',
       :dimensions => 'plane angle',
       :factor     => 2*Math::PI,
       :symbol     => 'rev',
       :j_science  => 'rev'

  load :label      => :reyn, 
       :name       => 'reyn',
       :dimensions => 'dynamic viscosity',
       :factor     => 689.5e3,
       :symbol     => 'reyn',
       :j_science  => 'reyn'

  load :label      => :rood, 
       :name       => 'rood',
       :dimensions => 'area',
       :factor     => 1.011714e3,
       :symbol     => 'rood',
       :j_science  => 'rood'

  load :label      => :Rd, 
       :name       => 'rutherford',
       :dimensions => 'radioactivity',
       :factor     => 1e6,
       :symbol     => 'rd',
       :j_science  => 'Rd'

  load :label      => :Ry, 
       :name       => 'rydberg',
       :dimensions => 'energy',
       :factor     => 2.179874e-18,
       :symbol     => 'Ry',
       :j_science  => 'Ry'

  load :label      => :ton_us, 
       :name       => 'short ton',
       :dimensions => 'mass',
       :factor     => 907.1847,
       :symbol     => 'ton',
       :j_science  => 'ton_us'

  load :label      => :day_sidereal, 
       :name       => 'sidereal day',
       :dimensions => 'time',
       :factor     => 86.16409053e3,
       :symbol     => 'd',
       :j_science  => 'day_sidereal'

  load :label      => :year_sidereal, 
       :name       => 'sidereal year',
       :dimensions => 'time',
       :factor     => 31558823.803728,
       :symbol     => 'yr',
       :j_science  => 'year_sidereal'

  load :label      => :lea, 
       :name       => 'statute league',
       :dimensions => 'length',
       :factor     => 4.828032e3,
       :symbol     => 'lea',
       :j_science  => 'lea'

  load :label      => :sphere, 
       :name       => 'sphere',
       :dimensions => 'solid angle',
       :factor     => 4*Math::PI,
       :symbol     => 'sphere',
       :j_science  => 'sphere'

  load :label      => :sn, 
       :name       => 'sthene',
       :dimensions => 'force',
       :factor     => 1e3,
       :symbol     => 'sn',
       :j_science  => 'sn'

  load :label      => :St, 
       :name       => 'stokes',
       :dimensions => 'kinematic viscosity',
       :factor     => 100e-6,
       :symbol     => 'St',
       :j_science  => 'St'

  load :label      => :st, 
       :name       => 'stone',
       :dimensions => 'mass',
       :factor     => 6.350293,
       :symbol     => 'st',
       :j_science  => 'st'

  load :label      => :thm, 
       :name       => 'therm',
       :dimensions => 'energy',
       :factor     => 105.506e6,
       :symbol     => 'thm',
       :j_science  => 'thm'

  load :label      => :th, 
       :name       => 'thermie',
       :dimensions => 'energy',
       :factor     => 4.185407e6,
       :symbol     => 'th',
       :j_science  => 'th'

  load :label      => :tog, 
       :name       => 'tog',
       :dimensions => 'thermal resistance',
       :factor     => 0.1,
       :symbol     => 'tog',
       :j_science  => 'tog'

  load :label      => :t, 
       :name       => 'tonne',
       :dimensions => 'mass',
       :factor     => 1000.0,
       :symbol     => 't',
       :j_science  => 't'

  load :label      => :u, 
       :name       => 'unified atomic mass',
       :dimensions => 'mass',
       :factor     => 1.66054e-27,
       :symbol     => 'u',
       :j_science  => 'u'

  load :label      => :bbl_imp, 
       :name       => 'UK barrel',
       :dimensions => 'volume',
       :factor     => 163.6592e-3,
       :symbol     => 'bl (Imp)',
       :j_science  => 'bbl_imp'

  load :label      => :oz_fl_uk, 
       :name       => 'UK fluid ounce',
       :dimensions => 'volume',
       :factor     => 28.41308e-6,
       :symbol     => 'fl oz',
       :j_science  => 'oz_fl_uk'

  load :label      => :gal_uk, 
       :name       => 'UK gallon',
       :dimensions => 'volume',
       :factor     => 4.546092e-3,
       :symbol     => 'gal',
       :j_science  => 'gal_uk'

  load :label      => :gi_uk, 
       :name       => 'UK gill',
       :dimensions => 'volume',
       :factor     => 142.0654e-6,
       :symbol     => 'gi',
       :j_science  => 'gi_uk'

  load :label      => :hp_uk, 
       :name       => 'UK horsepower',
       :dimensions => 'power',
       :factor     => 745.6999,
       :symbol     => 'hp',
       :j_science  => 'hp_uk'

  load :label      => :gallon_dry_us, 
       :name       => 'US dry gallon',
       :dimensions => 'volume',
       :factor     => 4.40488377086e-3,
       :symbol     => 'gal',
       :j_science  => 'gallon_dry_us'

  load :label      => :bbl_dry_us, 
       :name       => 'US dry barrel',
       :dimensions => 'volume',
       :factor     => 115.6271e-3,
       :symbol     => 'bl (US)',
       :j_science  => 'bbl_dry_us'

  load :label      => :oz_fl, 
       :name       => 'US fluid ounce',
       :dimensions => 'volume',
       :factor     => 29.57353e-6,
       :symbol     => 'fl oz',
       :j_science  => 'oz_fl'

  load :label      => :gi_us, 
       :name       => 'US gill',
       :dimensions => 'volume',
       :factor     => 118.2941e-6,
       :symbol     => 'gi',
       :j_science  => 'gi_us'

  load :label      => :bbl_fl_us, 
       :name       => 'US liquid barrel',
       :dimensions => 'volume',
       :factor     => 119.2405e-3,
       :symbol     => 'fl bl (US)',
       :j_science  => 'bbl_fl_us'

  load :label      => :gal, 
       :name       => 'US liquid gallon',
       :dimensions => 'volume',
       :factor     => 3.785412e-3,
       :symbol     => 'gal',
       :j_science  => 'gal'

  load :label      => :foot_survey_us, 
       :name       => 'US survey foot',
       :dimensions => 'length',
       :factor     => 304.8e-3,
       :symbol     => 'ft',
       :j_science  => 'foot_survey_us'

  load :label      => :week, 
       :name       => 'week',
       :dimensions => 'time',
       :factor     => 604800,
       :symbol     => 'wk',
       :j_science  => 'week'

  load :label      => :yd, 
       :name       => 'yard',
       :dimensions => 'length',
       :factor     => 0.9144,
       :symbol     => 'yd',
       :j_science  => 'yd'

  load :label      => :year, 
       :name       => 'year',
       :dimensions => 'time',
       :factor     => 31557600,
       :symbol     => 'yr',
       :j_science  => 'year'


  construct_and_load(kW*h) do |unit|
    unit.symbol    = 'kWh'
    unit.label     = 'kWh'
    unit.j_science = 'kWh'
  end

  construct_and_load(pound_force/(inch**2)) do |unit|
    unit.symbol = 'psi'
  end

  non_si_base_units.each { |unit| unit.acts_as_equivalent_unit = true }

  Dimensions.dimensionless.units.each { |unit| unit.acts_as_alternative_unit = false }

end
