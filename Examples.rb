Example

kW = Unit.kW                                                 #=> #<Quantify::Unit::SI:0xb7586620 ... >
h = Unit.h                                                   #=> #<Quantify::Unit::NonSI:0xb7582994 ... >
kWh = kW / h                                                 #=> #<Quantify::Unit::Compound:0xb756b0b4 ... >
kg = Unit.kg                                                 #=> #<Quantify::Unit::SI:0xb758b594 ... >
kg_per_kWh = b/a                                             #=> #<Quantify::Unit::Compound:0xb746f093 ... >

emission_factor = Quantity.new(0.54, kg_per_kWh)             #=> #<Quantify::Quantity:0xb75cd570 ... >
emission_factor.to_s                                         #=> "0.54 kg_kW_h"

consumption = Quantity.new(9885.5, kWh)                      #=> #<Quantify::Quantity:0xb7j4k3570 ... >
consumption.to_s                                             #=> "9885.5 kW_h"

emissions = consumption * emission_factor                    #=> #<Quantify::Quantity:0xb456g2s70 ... >
emissions.to_s                                               #=> "5338.17 kg"

----

unit = Unit.km                                               #=> #<Quantify::Unit::SI:0xb75c9718 ... >
unit.name                                                    #=> :kilometre
unit.symbol                                                  #=> :kg
unit.dimensions                                              #=> #<Quantify::Dimensions:0xb75c4254 .. >
unit.measures                                                #=> :length
unit.alternatives                                            #=> [:metre, :megametre, :gigametre, :terametre, :angstrom,
                                                             #    :astronomical_unit, :baromil, :chain, :dram, :ell, :fathom,
                                                             #    :fermi, :foot_us_survey, :foot, :furlong, :hand, :inch,
                                                             #    :nautical_league, :statute_league, :light_year, :line,
                                                             #    :link, :yard]
other_unit = Unit.tonne
unit * other_unit                                            #=> #<Quantify::Unit::Compound:0xb746f093 ... >

other_unit = Unit.hour
unit / other_unit                                            #=> #<Quantify::Unit::Compound:0xb74af323 ... >

unit ** 2                                                    #=> #<Quantify::Unit::Compound:0xb446f12f ... >

----

Quantity.new(1234.5678, :lb)                                 #=> #<Quantify::Quantity:0xjk39d570 ... >

Quantity.parse "1234.5678 lb"                                #=> #<Quantify::Quantity:0xj982b4f9 ... >

quantity = 1234.5678.lb                                      #=> #<Quantify::Quantity:02387f7340 ... >
quantity * 4                                                 #=> #<Quantify::Quantity:0b8787a688 ... >
quantity.to_ft                                               #=> #<Quantify::Quantity:0b8787a688 ... >

