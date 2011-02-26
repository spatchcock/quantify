
module Quantify
  module Unit
    class Compound < Base

      attr_reader :base_units

      # Initialize a compound unit by providing an array of hashes containing the
      # name or Unit object and the index (i.e. the power) of each base unit.
      #
      #   e.g. units = [ {:unit => :kilometre },
      #                  { :unit => :hour, :index => -1 }]
      #
      # Where no index is provided, this is assumed to be 1
      #
      def initialize(units=[])
        @base_units = []
        units.each do |unit|
          if unit[:unit].is_a? Quantify::Unit::Base
            base_unit = unit[:unit]
          else
            base_unit = Unit.for(unit[:unit])
          end

          if unit[:index].nil?
            index = 1
          else
            index = unit[:index]
          end
          @base_units << { :unit => base_unit, :index => index }
        end

        consolidate_base_units

        @dimensions = @base_units.inject(Dimensions.dimensionless) do |dimension,base|
          base[:unit].dimensions.pow! base[:index]
          dimension * base[:unit].dimensions
        end

        @symbol = @base_units.inject('') do |symbol,base|
          base_unit_index = ( base[:index].nil? or base[:index] == 1 ? "" : "^#{base[:index]}" )
          base_unit_symbol = base[:unit].symbol.to_s + base_unit_index
          symbol << "#{base_unit_symbol} "
        end.strip.gsub(" ", "_").to_sym
        
      end

      # This method consilidates base quantities by finding multiple instances
      # of the same unit type and reducing them into a single unit represenation
      # by altering the repsective index. It has the effect of raising units to
      # powers and cancelling those which appear in the numerator AND denominator
      #
      def consolidate_base_units
        new_base_units = []
        while @base_units.size > 0 do

          base = @base_units.shift

          # find any similar units, remove then from array so that they do not get
          # used in the following iterations. Sum the indices of all similar units

          base[:index] = @base_units.select do |hash|
            base[:unit] == hash[:unit]
          end.inject(base[:index]) do |index,hash|
            @base_units.delete hash
            index += hash[:index]
          end

          new_base_units << base

        end
        @base_units = new_base_units
      end

      def convert_base_unit(from,to)
        # change all specified units to new unot of same dimensions
      end

    end
  end
end
