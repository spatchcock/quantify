
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
        @dimensions = derive_dimensions
        @name = derive_name
        @symbol = derive_symbol
        @factor = derive_factor
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
          new_base_units << base unless base[:index] == 0
        end
        @base_units = new_base_units
      end

      def derive_dimensions
        @base_units.inject(Dimensions.dimensionless) do |dimension,base|
          dimension * (base[:unit].dimensions.pow base[:index])
        end
      end

      def derive_name
        unit_name = ""
        numerator_units.inject(unit_name) do |name,base|
          base_unit_index = ( base[:index].nil? or base[:index] == 1 ? "" : "^#{base[:index]}" )
          base_unit_name = base[:unit].name.to_s + base_unit_index
          name << "#{base_unit_name} "
        end
        unless denominator_units.empty?
          unit_name << "per "
          denominator_units.inject(unit_name) do |name,base|
            base_unit_index = ( base[:index].nil? or base[:index] == 1 ? "" : "^#{base[:index]}" )
            base_unit_name = base[:unit].name.to_s + base_unit_index
            name << "#{base_unit_name} "
          end
        end
        return unit_name.strip.gsub(" ", "_").to_sym
      end

      def derive_symbol
        @base_units.inject('') do |symbol,base|
          base_unit_index = ( base[:index].nil? or base[:index] == 1 ? "" : "^#{base[:index]}" )
          base_unit_symbol = base[:unit].symbol.to_s + base_unit_index
          symbol << "#{base_unit_symbol} "
        end.strip.gsub(" ", "_").to_sym
      end

      def derive_factor
        @base_units.inject(1) do |factor,base|
          factor * ( base[:unit].factor ** base[:index] )
        end
      end

      def numerator_units
        @base_units.select { |unit| unit[:index] > 0 }
      end

      def denominator_units
        @base_units.select { |unit| unit[:index] < 0 }
      end
      
      def convert_base_unit(from,to)
        # change all specified units to new unot of same dimensions
      end

    end
  end
end
