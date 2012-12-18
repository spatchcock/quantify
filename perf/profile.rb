# encoding: UTF-8
require 'perftools'
require 'active_support/inflector'
require './lib/quantify/quantify'
require './lib/quantify/core_extensions/string'
require './lib/quantify/core_extensions/symbol'
require './lib/quantify/core_extensions/numeric'
require './lib/quantify/core_extensions/range'
require './lib/quantify/inflections'
require './lib/quantify/exception'
require './lib/quantify/dimensions'
require './lib/quantify/unit/prefix/prefix'
require './lib/quantify/unit/prefix/base_prefix'
require './lib/quantify/unit/prefix/si_prefix'
require './lib/quantify/unit/prefix/non_si_prefix'
require './lib/quantify/unit/unit'
require './lib/quantify/unit/base_unit'
require './lib/quantify/unit/si_unit'
require './lib/quantify/unit/non_si_unit'
require './lib/quantify/unit/compound_base_unit_list'
require './lib/quantify/unit/compound_base_unit'
require './lib/quantify/unit/compound_unit'
require './lib/quantify/quantity'
require './lib/quantify/config'


puts "Starting profiler"

puts "[ Quantity#to_si ]"
quantity = Quantity.new(100, 'mV')
PerfTools::CpuProfiler.start("perf/quantity_to_si.profile") do
  1000.times do |n|
    quantity.to_si
  end
end

puts "[ Unit#for ]"
PerfTools::CpuProfiler.start("perf/unit_for.profile") do
  1000.times do |n|
    Unit.for("m² kg/s³ A") #si_unit for Volt
  end
end

