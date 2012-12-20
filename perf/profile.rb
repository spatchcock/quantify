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

puts "[ Unit#for 'm² kg/s³ A' ]"
PerfTools::CpuProfiler.start("perf/results/unit_for_complex.profile") do
  1000.times do |n|
    Unit.for("m² kg/s³ A") #si_unit for Volt
  end
end

puts "[ Unit#for 'cm' ]"
PerfTools::CpuProfiler.start("perf/results/unit_for_string.profile") do
  1000.times do |n|
    Unit.for("cm")
  end
end

puts "[ Unit#for :cm ]"
PerfTools::CpuProfiler.start("perf/results/unit_for_symbol.profile") do
  1000.times do |n|
    Unit.for(:cm)
  end
end

puts "[ Quantity#to_si ]"
quantity = Quantity.new(100, 'mV')
PerfTools::CpuProfiler.start("perf/results/quantity_to_si.profile") do
  1000.times do |n|
    quantity.to_si
  end
end

puts "[ Quantity#new(100,'mv') ]"
PerfTools::CpuProfiler.start("perf/results/quantity_new.profile") do
  1000.times do |n|
    Quantity.new(100, 'mV')
  end
end

puts "[ Quantity#parse('100 m² kg/s³ A')]"
PerfTools::CpuProfiler.start("perf/results/quantity_parse.profile") do
  1000.times do |n|
    Quantity.parse('100 m² kg/s³ A')
  end
end
