
module Quantify
  module Unit
    class Compound < Base

      # Compound units are units made up of two or more units and powers thereof.
      #
      # The relationships between these units represent multiplication or division.
      # E.g. a 'kilowatt hour' is the unit derived from multiplying a kilowatt and
      # an hour. The 'kilogram per cubic metre' similarly represents the kilogram
      # divided by the cubic metre (which itself represents metre x metre x metre).
      #
      # There are many SI units and NonSI units which are technically compound
      # units - being derived from several base units. For example, the watt
      # represents the joule (itself compound) divided by the second. In this
      # case though, the use of a special name for the unit - the 'watt' rather
      # than the 'kilogram square metre per cubic second' - allows it to be
      # treated as a standard SI unit.
      #
      # The Compound class provides support for arbitrarily defined compound units
      # which don't have well-established names.

      attr_reader :base_units

      # Initialize a compound unit by providing an array of hashes containing the
      # name or Unit object and the index (i.e. the power) of each base unit.
      #
      #   e.g. units = [ {:unit => :kilometre },
      #                  { :unit => :hour, :index => -1 }]
      #
      # Where no index is provided, this is assumed to be 1.
      #
      # Base units are held within the @base_units instance variable.
      #
      def initialize(units=[])
        @base_units = []
        units.each do |unit|
          if unit[:unit].is_a? Quantify::Unit::Base
            base_unit = unit[:unit].deep_clone
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
          next if base[:unit].dimensions.is_dimensionless?
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

      # Derive a representation of the physical dimensions of the compound unit
      # by multilying together the dimensions of each of the base units.
      #
      def derive_dimensions
        @base_units.inject(Dimensions.dimensionless) do |dimension,base|
          dimension * (base[:unit].dimensions.pow base[:index])
        end
      end

      # Derive a name for the unit based on the names of the base units
      def derive_name
        unit_name = ""
        unless numerator_units.empty?
          numerator_units.inject(unit_name) do |name,base|
            base_unit_index = ( base[:index] == 1 ? "" : "^#{base[:index]}" )
            base_unit_name = base[:unit].name + base_unit_index
            name << "#{base_unit_name} "
          end
        end
        unless denominator_units.empty?
          unit_name << "per "
          denominator_units.inject(unit_name) do |name,base|
            base_unit_index = ( base[:index] == -1 ? "" : "^#{base[:index]}" )
            base_unit_name = base[:unit].name + base_unit_index
            name << "#{base_unit_name} "
          end
        end
        return unit_name.strip
      end

      # Derive a symbol for the unit based on the symbols of the base units
      def derive_symbol
        @base_units.inject('') do |symbol,base|
          base_unit_index = ( base[:index].nil? or base[:index] == 1 ? "" : "^#{base[:index]}" )
          base_unit_symbol = base[:unit].symbol.to_s + base_unit_index
          symbol << "#{base_unit_symbol} "
        end.strip
      end

      # Derive the multiplicative factor for the unit based on those of the base
      # units
      #
      def derive_factor
        @base_units.inject(1) do |factor,base|
          factor * ( base[:unit].factor ** base[:index] )
        end
      end

      # Returns an array containing only the base units which have positive indices
      def numerator_units
        @base_units.select { |unit| unit[:index] > 0 }
      end

      # Returns an array containing only the base units which have negative indices
      def denominator_units
        @base_units.select { |unit| unit[:index] < 0 }
      end
      
      def convert_base_unit(from,to)
        # change all specified units to new unot of same dimensions
      end

      # Determine is a unit object represents an SI named unit.
      #
      # Iterate through all base units looking for a single instance of a non-SI
      # unit. Coumpound units are only SI if they are entirely composed of SI
      # units
      #
      def is_si?
        # if this expression is false - i.e. no instance of an SI check returning
        # false occurs - return true... The unit is an SI unit.
        !@base_units.inject(false) do |status,unit|
          status ||= !unit[:unit].is_si?
        end
      end

      # Determine if a unit instance is the same as a known unit.
      #
      # This can be used to determine if the compound unit which was derived from
      # some operation simply represents a known, established unit, which can then
      # be returned instead of representing the unit as an instance of the Compound
      # class.
      #
      # This has the advantage of enabling the use of SI and NonSI specific methods
      # and prefixes.
      #
      def new_unit_or_known_unit
        return self unless known_unit = Unit.units.find do |unit|
          unit == self and !unit.is_compound_unit?
        end
        return known_unit
      end

    end
  end
end
