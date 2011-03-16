
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
        @label = derive_label
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
      #
      # Both singluar and plural names can be derived. In the case of pluralized
      # names, the last unit in the numerator is pluralized.
      #
      # Singular names are assumed by default, in which case no argument is
      # required.
      #
      def derive_name(inflection=:singular)
        unit_name = ""
        unless numerator_units.empty?
          names_and_indices = numerator_units.map do |base|
            [ base[:unit].name, base[:index] ]
          end

          if inflection == :plural
            last_unit = names_and_indices.pop
            names_and_indices.push [ last_unit[0].pluralize, last_unit[1] ]
          end

          names_and_indices.inject(unit_name) do |name,base|
            name << "#{base[0].to_power base[1]} "
          end
        end
        unless denominator_units.empty?
          unit_name << "per "
          denominator_units.inject(unit_name) do |name,base|
            name << "#{base[:unit].name.to_power(base[:index]*-1)} "
          end
        end
        return unit_name.strip
      end

      # Derive a symbol for the unit based on the symbols of the base units
      # 
      # Get the units in order first so that the denominator values (i.e. those
      # with negative powers) follow the numerators
      #
      def derive_symbol
        @base_units.sort do |unit,next_unit|
          next_unit[:index] <=> unit[:index]
        end.inject('') do |symbol,base|
          base_unit_index = ( base[:index].nil? or base[:index] == 1 ? "" : "^#{base[:index]}" )
          base_unit_symbol = base[:unit].symbol.to_s + base_unit_index
          symbol << "#{base_unit_symbol} "
        end.strip
      end

      def derive_label
        unit_label = ""
        unless numerator_units.empty?
          numerator_units.inject(unit_label) do |label,base|
            base_unit_index = ( base[:index].nil? or base[:index] == 1 ? "" : "^#{base[:index]}" )
            base_unit_label = base[:unit].label + base_unit_index
            label << "#{base_unit_label}·"
          end
        end
        unit_label.gsub!("·","") unless unit_label.empty?
        unless denominator_units.empty?
          if unit_label.empty?
            denominator_units.inject(unit_label) do |label,base|
              base_unit_index = ( base[:index].nil? or base[:index] == 1 ? "" : "^#{base[:index]}" )
              base_unit_label = base[:unit].label + base_unit_index
              label << "#{base_unit_label}·"
            end
          else
            unit_label << "/"
            denominator_units.inject(unit_label) do |label,base|
              base_unit_index = ( base[:index].nil? or base[:index] == -1 ? "" : "^#{base[:index]*-1}" )
              base_unit_label = base[:unit].label + base_unit_index
              label << "#{base_unit_label}·"
            end
          end
        end
        return unit_label.chop.chop
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

      # Convenient accessor method for pluralized names
      def pluralized_name
        derive_name :plural
      end

      # Determine is a unit object represents an SI named unit.
      #
      # Iterate through all base units looking for a single instance of a non-SI
      # unit. Coumpound units are only SI if they are entirely composed of SI
      # units
      #
      def is_si_unit?
        # if this expression is false - i.e. no instance of an SI check returning
        # false occurs - return true... The unit is an SI unit.
        not @base_units.inject(false) do |status,unit|
          status ||= !unit[:unit].is_si_unit?
        end
      end

      # This can be used to determine if the compound unit which was derived from
      # some operation simply represents a known, established unit, which can then
      # be returned instead of representing the unit as an instance of the Compound
      # class.
      #
      # This has the advantage of enabling the use of SI and NonSI specific methods
      # and prefixes.
      #
      def or_equivalent_known_unit
        return self unless known_unit = Unit.units.find do |unit|
          unit == self and not unit.is_compound_unit?
        end
        return known_unit
      end

    end
  end
end
