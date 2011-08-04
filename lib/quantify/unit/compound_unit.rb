
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

      attr_reader :base_units, :acts_as_equivalent_unit

      # Initialize a compound unit by providing an array containing a represenation
      # of each base unit.
      #
      # Array may contain elements specified as follows:
      #
      #  1. a instance of CompoundBaseUnit
      #
      #  2. an instance of Unit::Base (in which case its index is assumed as 1
      #
      #  3. a sub-array of size 2 containing an instance of Unit::Base and an
      #     explicit index
      #
      def initialize(*units)
        @base_units = CompoundBaseUnitList.new
        units.each do |unit|
          if unit.is_a? CompoundBaseUnit
            @base_units << unit
          elsif unit.is_a? Unit::Base
            @base_units << CompoundBaseUnit.new(unit)
          elsif unit.is_a?(Array) && unit.first.is_a?(Unit::Base) &&
              !unit.first.is_a?(Compound) && unit.size == 2
            @base_units << CompoundBaseUnit.new(unit.first,unit.last)
          else
            raise Exceptions::InvalidArgumentError, "#{unit} does not represent a valid base unit"
          end
        end
        @acts_as_alternative_unit = true
        @acts_as_equivalent_unit = false
        consolidate_numerator_and_denominator_units!
      end

      # Refresh all unit attributes. Can be used following a change to unit attribute
      # global configurations
      #
      def refresh_attributes
        initialize_attributes
      end

      # Returns an array containing only the base units which have positive indices
      def numerator_units
        @base_units.numerator_units
      end

      # Returns an array containing only the base units which have negative indices
      def denominator_units
        @base_units.denominator_units
      end

      # Convenient accessor method for pluralized names
      def pluralized_name
        @base_units.name(true)
      end

      # Determine is a unit object represents an SI named unit.
      def is_si_unit?
        @base_units.is_si_unit?
      end

      def is_non_si_unit?
        @base_units.is_non_si_unit?
      end

      def is_base_quantity_si_unit?
        @base_units.is_base_quantity_si_unit?
      end

      def has_multiple_base_units?
        @base_units.size > 1
      end

      # Return a known unit which is equivalent to self in terms of its physical
      # quantity (dimensions), factor and scaling attributes (i.e. representing the
      # precise same physical unit but perhaps with different identifiers), e.g.
      #
      #   ((Unit.kg*(Unit.m**"))/(Unit.s**2)).equivalent_known_unit.name
      #
      #                                #=> "joule"
      #
      def equivalent_known_unit
        Unit.units.find do |unit|
          self.is_equivalent_to?(unit) && !unit.is_compound_unit?
        end
      end

      # Returns an equivalent known unit (via #equivalent_known_unit) if it exists.
      # Otherwise, returns false.
      #
      def or_equivalent
        equivalent_unit = equivalent_known_unit
        if equivalent_unit && equivalent_unit.acts_as_equivalent_unit
          return equivalent_unit
        else
          return self
        end
      end

      # Cancel base units across numerator and denominator. If similar units occur
      # in both the numerator and denominator, they can be cancelled, i.e. their
      # powers reduced correspondingly until one is removed.
      #
      # This method is useful when wanting to remove specific units that can be
      # cancelled from the compound unit configuration while retaining the
      # remaining units in the current format.
      #
      # If no other potentially cancelable units need to be retained, the method
      # #consolidate_base_units! can be called with the :full argument instead
      #
      # This method takes an arbitrary number of arguments which represent the units
      # which are required to be cancelled (string, symbol or object)
      #
      def cancel_base_units!(*units)
        @base_units.cancel!(*units)
        initialize_attributes
      end

      # Consilidates base quantities by finding multiple instances of the same unit
      # type and reducing them into a single unit represenation, by altering the
      # repsective index. It has the effect of raising units to powers and cancelling
      # those which appear in the numerator AND denominator
      #
      def consolidate_base_units!
        @base_units.consolidate!
        initialize_attributes
      end

      # Similar to #consolidate_base_units! but operates on the numerator and
      # denomiator are separately. This means that two instances of the same unit
      # should not occur in the numerator OR denominator (rather they are combined
      # and the index changed accordingly), but similar units are not cancelled
      # across the numerator and denominators.
      #
      def consolidate_numerator_and_denominator_units!
        @base_units.consolidate_numerator_and_denominator!
        initialize_attributes
      end

      # Make compound unit use consistent units for representing each physical
      # quantity. For example, lb/kg => kg/kg.
      #
      # The units to use for particular physical dimension can be specified. If
      # no unit is specified for a physical quantity which is represented in the
      # <tt>self</tt>, then the first unit found for that physical quantity is
      # used as the canonical one.
      #
      def rationalize_base_units!(*units)
        @base_units.rationalize!(*units)
        initialize_attributes
      end

      # Similar to #rationalize_base_units! but operates on the numerator and
      # denomiator are separately. This means that different units representing
      # the same physical quantity may remain across the numerator and
      # denominator units.
      #
      def rationalize_numerator_and_denominator_units!(*units)
        @base_units.rationalize_numerator_and_denominator!(*units)
        initialize_attributes
      end

      private

      def initialize_attributes
        self.dimensions = @base_units.dimensions
        self.name = @base_units.name
        self.symbol = @base_units.symbol
        self.factor = @base_units.factor
        self.label = @base_units.label
        return self
      end

      def options_for_prefixed_version(prefix)
        raise Exceptions::InvalidArgumentError, "No valid prefixes exist for unit: #{self.name}" if has_multiple_base_units?
        base = @base_units.first
        base.unit = base.unit.with_prefix(prefix)
        return base
      end

      def initialize_copy(source)
        super
        instance_variable_set("@base_units", @base_units.clone)
      end

    end
  end
end