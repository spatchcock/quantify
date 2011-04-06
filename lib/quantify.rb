
# The Quantify library provides a system for handling physical quantities. Physical
# quantities are represented by a value and a unit. Quantities can be added,
# subtracted, multiplied, etc. or converted into alternative units
#

require 'pp'
require 'rubygems'
require 'active_support/inflector'
require 'quantify/core_extensions'
require 'quantify/inflections'
require 'quantify/exception'
require 'quantify/dimensions'
require 'quantify/prefix'
require 'quantify/unit/unit'
require 'quantify/unit/base_unit'
require 'quantify/unit/si_unit'
require 'quantify/unit/non_si_unit'
require 'quantify/unit/compound_base_unit'
require 'quantify/unit/compound_unit'
require 'quantify/quantity'
require 'quantify/quantify'
require 'quantify/config'
