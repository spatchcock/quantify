Quantify
========

A gem to support physical quantities and unit conversions in Ruby

Licensed under the MIT license (See COPYING file for details)

Author: Andrew Berkeley (andrew.berkeley.is@googlemail.com)

Homepage: https://github.com/spatchcock/quantify 


Quick introduction
------------------
```ruby
    # Operating on quantities

    12.feet + 12.feet                   #=> "24.0 feet"

    6.m ** 2                            #=> "36.0 m²"

    100.km / 2.h                        #=> "50 kilometers per hour"

    5000.L.to_bbl                       #=> "31.4490528488754 barrels"

    1.5.lb.to_si.round(2)               #=> "0.68 kg"

    Unit.ratio :kg, :ton                #=> "1016.047 kilograms per long ton"
```
Note: these results are string representations of the actual objects
which result from these operations, using the Quantity#to_s method which
renders quantities using either the unit name or symbol.

    # Handling units

    Unit.ton.name                       #=> "long ton"

    Unit.ton.label                      #=> "ton_uk"

    Unit.ton.measures                   #=> "mass"

    Unit.ton.alternatives :name         #=> [ "kilogram",
                                              "gram",
                                              "carat",
                                              "electron mass",
                                              "grain",
                                              "hundredweight long",
                                              "hundredweight short",
                                              "ounce",
                                              "pennyweight",
                                              "pound",
                                              "short ton",
                                              "stone",
                                              "tonne",
                                              "unified atomic mass" ]
 
    Unit.ton.si_unit                    #=> 'kg'

    Unit.ton.dimensions                 #=> <Quantify::Dimensions:0xb75467c8 ... >

    Unit.ton.dimensions.describe        #=> "mass"

    Unit.ton.dimensions.mass            #=> 1

    Unit.ton.dimensions.length          #=> nil

    
General introduction
--------------------

Quantify represents physical quantities using the Quantify::Quantity class.

A Quantity object holds both a value (Numeric) and a unit (of the class
Quantify::Unit::Base), for example a Quantity object might represent 12 kgs (value, 12; unit, kilogram).

Quantities can be manipulated and operated on, in all of the ways that might be required for real physical quantities. Operations include, addition, subtraction, multiplying and dividing by scalar values or other quantities, raising to powers, converting into alternative unit representations (e.g. kgs to lbs, miles per hour to metres per second), and rounding of values. Quantify handles the converting of both values and units so that the result is a an accurate representation of the operation. For example, multiplying 10 metres by 10 metres will result in a quanity of square metres, whereas dividing, say, 10 metres by 2 seconds will result in a quantity in metres per second.

In all cases the results of operations are a changes to the Quantity instance or a new instance of a Quantity object. The new value or unit can be accessed using the #value and #unit attributes, or the #to_s method which renders the quantity in string form.

There are several ways to initialize a quantity object

    mass = Quantity.new(100,:lb)          #=> <Quantify::Quantity:0xb7332bbc ... >
    mass = Quantity.new(100,'pound')      #=> <Quantify::Quantity:0xb7332bbc ... >
    mass = 100.lb                         #=> <Quantify::Quantity:0xb7332bbc ... >
    mass = 100.pound                      #=> <Quantify::Quantity:0xb7332bbc ... >
    mass = Quantity.parse "100 lb"        #=> <Quantify::Quantity:0xb7332bbc ... >
    mass = "100 lb".to_q                  #=> <Quantify::Quantity:0xb7332bbc ... >

Quantity object can be insterrogated for a range of attributes

    mass.value                            #=> 100.0
    mass.unit                             #=> <Quantify::Unit::NonSI:0xb7332b08 ... >
    mass.unit.name                        #=> "pound"
    mass.unit.symbol                      #=> "lb"

    # unique identifier, follows JScience
    mass.unit.label                       #=> "lb"
    mass.unit.pluralized_name             #=> "pounds"
    mass.to_s                             #=> "100 lb"
    mass.to_s(:name)                      #=> "100 pounds"

    # Describe the physical quantity represented by the quantity
    mass.represents                       #=> "mass"

Convert a quantity to a different unit

    energy = 100.kWh                      #=> "100 kilowatt hours"
  
    new_energy = energy.to_megajoules     #=> "360.0 MJ"
  
    new_energy = energy.to_MJ             #=> "360.0 MJ"
  
    new_energy = energy.to(:MJ)           #=> "360.0 MJ"

    # Initialize a unit object and pass as conversion argument
    unit = Unit.MJ                        #=> <Quantify::Unit::SI:0xb75c9718 ... >
    new_energy = energy.to(unit)          #=> "360.0 MJ"

Convert the units of a quantity with a compound unit

    speed = 70.mi/1.h                     #=> "70.0 mi/h"

    speed_in_kms = speed.to_km            #=> "112.65408 km/h"

    speed_in_mins = speed_in_kms.to_min   #=> "1.877568 km/min"

Convert a quantity to the corresponding SI unit

    energy = 100.kWh                      #=> "100 kWh"
    si = quantity.to_si                   #=> "360000000.0 J"

Operate on a quantity

    mass = 10.kg * 3                      #=> "30.0 kg"

    distance = 100.light_years / 20       #=> "5.0 ly"

    area = 10.m * 10.m                    #=> "100.0 square metres"

    speed = 250.mi / 3.h                  #=> "83.3333333333333 miles per hour"

    speed = 70.mi/1.h                     #=> <Quantify::Quantity:0xb7332bbc ... >
    time = 0.5.h                          #=> <Quantify::Quantity:3xf3472hjc ... >
    distance = speed * time               #=> <Quantify::Quantity:7d7f8g9d5g ... >
    distance.to_s                         #=> "35.0 mi"

Note: all of the above results are string representations of the actual
objects which result from these operations.

Additional operations
---------------------

The result of quantity operations is commonly a new quantity with a compound unit. Unless the result is equivalent to one of the base SI units (m, kg, s, K, etc.) or one of the following, square metre, cubic metre, joule, watt, newton or pascal, then the compound unit represents appropriate combination of the units involved, albeit with any like-units within the numerator and denominator grouped under a single
power/index.

Units are not automatically cancelled or rationalized (made consistent). This is because it cannot be assumed that that is the desire of the user. For example, a quantity with units <mass> per <mass> is technically dimensionless, but the user might prefer to explicitly represent the units rather than reduce to a dimensionless quantity. In addition, this quantity might be expressed in terms of grams per tonne,
and the user may not necessarily prefer a conversion into consistent mass units (e.g. g/g or t/t). Therefore, the following methods are available...

Where units representing the same physical quantity appear together, they can be made consistent by simply converting to the unit which is desired:
    
    area = 12.yd * 36.ft                  #=> <Quantify::Quantity:0xb7332bbc ... >
    area.to_s                             #=> "432.0 yd ft"
    area.to_yd
    area.to_s                             #=> "144.0 yd²"

Alternatively, all units within the numerator and denominator respectively can be standardized:

    quantity = (12.ft*8.mi)/(1.s*8.min)
    quantity.to_s                         #=> 12.0 ft mi/s min
    quantity.rationalize_units!
    quantity.to_s                         #=> 1056.0 ft²/s²

A quantity with arbitrary cancelable units can be cancelled manually:

    quantity = (12.m**6) / 2.m**2
    quantity.to_s                         #=> "746496.0 m^6/m²"
    quantity.cancel_base_units! :m
    quantity.to_s                         #=> "746496.0 m^4"

Note: there are more comprehensive and flexible methods for manupulating compound units available as part of of the class Unit::Compound. These can be used to convert a conpound unit into the precise form required. If such an approach is used, any quantity object can be converted to the new form by simply passing the new unit object into the Quantity#to method.