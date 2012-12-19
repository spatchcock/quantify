# encoding: UTF-8
require 'benchmark'
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

puts "Starting benchmark..."

Benchmark.bm do |bm|

  puts "[ Unit#for 'm² kg/s³ A' ]"
  bm.report do
    100.times do |n|
      Unit.for("m² kg/s³ A") #si_unit for Volt
    end
  end

  puts "[ Unit#for 'cm' ]"
  bm.report do
    100.times do |n|
      Unit.for("V") #si_unit for Volt
    end
  end

  puts "[ Unit#for :cm ]"
  bm.report do
    100.times do |n|
      Unit.for(:cm) #si_unit for Volt
    end
  end

  puts "[ Quantity#to_si ]"
  quantity = Quantity.new(100, 'mV')
  bm.report do
    100.times do |n|
      quantity.to_si
    end
  end

  puts "[ Quantity#new(100, 'mV') ]"
  bm.report do
    100.times do |n|
      Quantity.new(100, 'mV')
    end
  end

  puts "[ Quantity#parse('100 m² kg/s³ A') ]"
  bm.report do
    100.times do |n|
      Quantity.parse('100 m² kg/s³ A')
    end
  end

end

