
Quantify::Unit.configure do

  unload [ :inverse_centimetre,
           :galileo,
           :micrometre,
           :centiradian,
           :acre,
           :angstrom,
           :arcminute,
           :arcsecond,
           :are,
           :astronomical_unit,
           :barn,
           :biot,
           :BTU_IT,
           :BTU_ThirtyNineF,
           :BTU_Mean,
           :BTU_ISO,
           :BTU_SixtyF,
           :BTU_SixtyThreeF,
           :BTU_Thermochemical,
           :bushel_uk,
           :bushel_us,
           :byte,
           :candle_power,
           :carat,
           :celsius_heat_unit,
           :centimetre_of_mercury,
           :centimetre_of_water,
           :chain,
           :us_cup,
           :sidereal_day,
           :degree,
           :dram,
           :dyne,
           :dyne_centimetre,
           :electron_mass,
           :electron_volt,
           :erg,
           :ell,
           :faraday,
           :fathom,
           :fermi,
           :us_survey_foot,
           :franklin,
           :foot_of_water,
           :footcandle,
           :furlong,
           :gamma,
           :gauss,
           :uk_gill,
           :us_gill,
           :grad,
           :grain,
           :hartree,
           :hogshead,
           :boiler_horsepower,
           :electric_horsepower,
           :metric_horsepower,
           :uk_horsepower,
           :hundredweight_long,
           :hundredweight_short,
           :inch_of_mercury,
           :inch_of_water,
           :kilocalorie,
           :kilogram_force,
           :knot,
           :lambert,
           :nautical_league,
           :statute_league,
           :light_year,
           :line,
           :link,
           :maxwell,
           :millibar,
           :millimetre_of_mercury,
           :point,
           :parsec,
           :pennyweight,
           :poncelot,
           :poundal,
           :pound_force,
           :quad,
           :rad,
           :revolution,
           :reyn,
           :rem,
           :rood,
           :rutherford,
           :rydberg,
           :sphere,
           :sthene,
           :stokes,
           :therm,
           :thermie,
           :unified_atomic_mass,
           :sidereal_year,
           :tog,
           :clo ]

end

Quantify::Unit::SI.configure do

  prefix_and_load [:mega,:giga], :gram
  prefix_and_load [:mega,:giga,:tera], :joule
  prefix_and_load [:kilo,:mega], :watt

end

Quantify::Unit::NonSI.configure do

  BTU_FiftyNineF.operate do |unit|
    unit.name = 'british thermal unit'
    unit.symbol = 'BTU'
    unit.make_canonical
  end

  MMBTU_FiftyNineF.load

  construct_and_load(MW*h) do |unit|
    unit.symbol = 'MWh'
    unit.label = 'MWh'
  end
  
end