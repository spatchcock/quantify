# encoding: UTF-8

module Quantify
  module Unit
    class CompoundBaseUnitList < Array

      # Returns a string represents of the units contained within <tt>units</tt>
      # based on <tt>attribute</tt> and <tt>unit_delimiter</tt>.
      #
      def self.attribute_string(units,attribute,unit_delimiter,reciprocal=false)
        string = ""

        units.each do |base|
          string << unit_delimiter unless string.empty?
          string << base.send(attribute,reciprocal)
        end

        return string
      end

      # Returns an CompoundBaseUnitList containing only the base units which have
      # positive indices
      def numerator_units
        CompoundBaseUnitList.new select { |base| base.is_numerator? }
      end

      # Returns an CompoundBaseUnitList containing only the base units which have
      #  negative indices
      def denominator_units
        CompoundBaseUnitList.new select { |base| base.is_denominator? }
      end

      # Returns <tt>true</tt> if all base untis are SI units
      def is_si_unit?
        all? { |base| base.is_si_unit? }
      end

      # Returns <tt>true</tt> if all base untis are not SI units
      def is_non_si_unit?
        any? { |base| base.is_non_si_unit? }
      end

      # Returns <tt>true</tt> if all base untis are SI base units
      def is_base_quantity_si_unit?
        all? { |base| base.is_base_quantity_si_unit? }
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
      def cancel!(*units)
        units.each do |unit|
          raise Exceptions::InvalidArgumentError, "Cannot cancel by a compound unit" if unit.is_a? Unit::Compound

          unit = Unit.for unit unless unit.is_a? Unit::Base

          numerator_unit   = numerator_units.find   { |base| unit.is_equivalent_to? base.unit }
          denominator_unit = denominator_units.find { |base| unit.is_equivalent_to? base.unit }

          if numerator_unit && denominator_unit
            cancel_value = [numerator_unit.index,denominator_unit.index].min.abs

            numerator_unit.index   -= cancel_value
            denominator_unit.index += cancel_value
          end
        end

        consolidate_numerator_and_denominator!
      end

      # Consilidates base quantities by finding multiple instances of the same unit
      # type and reducing them into a single unit represenation, by altering the
      # repsective index. It has the effect of raising units to powers and cancelling
      # those which appear in the numerator AND denominator
      #
      # This is a class method which takes an arbitrary array of base units as an
      # argument. This means that consolidation can be performed on either all
      # base units or just a subset - the numerator or denominator units.
      #
      def consolidate!
        new_base_units = []

        while size > 0 do
          new_base = shift
          next if new_base.unit.is_dimensionless?

          new_base.index = select do |other_base|
            new_base.unit.is_equivalent_to? other_base.unit
          end.inject(new_base.index) do |index,other_base|
            delete other_base
            index += other_base.index
          end

          new_base_units << new_base unless new_base.is_dimensionless?
        end
        
        replace(new_base_units)
      end

      # Similar to #consolidate_base_units! but operates on the numerator and denomiator
      # are separately. This means that two instances of the same unit
      # should not occur in the numerator OR denominator (rather they are combined
      # and the index changed accordingly), but similar units are not cancelled
      # across the numerator and denominators.
      #
      def consolidate_numerator_and_denominator!
        replace(numerator_units.consolidate! + denominator_units.consolidate!)
      end

      # Make compound unit use consistent units for representing each physical
      # quantity. For example, lb/kg => kg/kg.
      #
      # The units to use for particular physical dimension can be specified. If
      # no unit is specified for a physical quantity which is represented in the
      # <tt>self</tt>, then the first unit found for that physical quantity is
      # used as the canonical one.
      #
      def rationalize!(*required_units)
        each do |base|
          new_unit = required_units.map { |unit| Unit.for(unit) }.find { |unit| unit.dimensions == base.unit.dimensions } ||
            find { |other_base| other_base.unit.dimensions == base.unit.dimensions }.unit
          base.unit = new_unit
        end

        consolidate_numerator_and_denominator!
      end

      # Similar to #rationalize_base_units! but operates on the numerator and
      # denomiator are separately. This means that different units representing
      # the same physical quantity may remain across the numerator and
      # denominator units.
      #
      def rationalize_numerator_and_denominator!(*units)
        replace(numerator_units.rationalize!(*units) + denominator_units.rationalize!(*units))
      end

      # Derive a representation of the physical dimensions of the compound unit
      # by multilying together the dimensions of each of the base units.
      #
      def dimensions
        inject(Dimensions.dimensionless) { |dimension,base| dimension * base.dimensions }
      end

      # Derive a name for the unit based on the names of the base units
      #
      # Both singluar and plural names can be derived. In the case of pluralized
      # names, the last unit in the numerator is pluralized. Singular names are
      # assumed by default, in which case no argument is required.
      #
      # Format for names includes the phrase 'per' to differentiate denominator
      # units and words, rather than numbers, for representing powers, e.g.
      #
      #   square metres per second
      #
      def name(plural=false)
        attribute_string_with_denominator_syntax(:name, " per ", " ", plural)
      end

      # Derive a symbol for the unit based on the symbols of the base units
      #
      # Get the units in order first so that the denominator values (those
      # with negative powers) follow the numerators
      #
      # Symbol format use unit symbols, with numerator symbols followed by
      # denominator symbols and powers expressed using the "^" notation with 'true'
      # values (i.e. preservation of minus signs).
      #
      def symbol
        if Unit.use_symbol_denominator_syntax?
          attribute_string_with_denominator_syntax(:symbol,Unit.symbol_denominator_delimiter, Unit.symbol_unit_delimiter)
        else
          attribute_string_with_indices_only(:symbol,Unit.symbol_unit_delimiter)
        end
      end

      # Derive a label for the comound unit. This follows the format used in the
      # JScience library in using a middot notation ("·") to spearate units and
      # slash notation "/" to separate numerator and denominator. Since the
      # denominator is differentiated, denominator unit powers are rendered in
      # absolute terms (i.e. minus sign omitted) except when no numerator values
      # are present.
      #
      def label
        attribute_string_with_denominator_syntax(:label, "/", "·")
      end

      # Derive the multiplicative factor for the unit based on those of the base
      # units
      #
      def factor
        inject(1) { |factor,base| factor * base.factor }
      end

      private
      
      def initialize_copy(source)
        super
        map! { |base_unit| base_unit.clone }
      end

      # Return a string representing an attribute of <tt>self</tt> containing
      # no numerator-denominator structure but rather representing each unit
      # entirely in terms of a unit and and index. e.g. m s^-1
      #
      def attribute_string_with_indices_only(attribute,unit_delimiter)
        units = sort { |base,next_unit| next_unit.index <=> base.index }
        CompoundBaseUnitList.attribute_string(units,attribute,unit_delimiter).strip
      end

      # Return a string representing an attribute of <tt>self</tt> containing a
      # numerator-denominator structure, e.g. m/s
      #
      def attribute_string_with_denominator_syntax(attribute,denominator_delimiter,unit_delimiter,plural=false)

        attribute          = attribute.to_sym
        numerator_string   = ""
        denominator_string = ""
        numerator_units    = self.numerator_units
        denominator_units  = self.denominator_units

        unless numerator_units.empty?
          numerator_units_size = numerator_units.size

          # Handle pluralisation of last unit if pluralised form required, e.g.
          # tonne kilometres per hour
          last_unit = numerator_units.pop if attribute == :name && plural == true
          numerator_string << CompoundBaseUnitList.attribute_string(numerator_units,attribute,unit_delimiter)
          numerator_string << unit_delimiter + last_unit.pluralized_name if last_unit

          if Unit.use_symbol_parentheses?
            if numerator_units_size > 1 && !denominator_units.empty?
              numerator_string = "(#{numerator_string.strip})"
            end
          end
        end
        
        unless denominator_units.empty?
          # If no numerator exists then indices should be reciprocalized since
          # they do NOT occur after the denominator delimiter (e.g. "/")

          reciprocal = !numerator_string.empty?
          denominator_string << CompoundBaseUnitList.attribute_string(denominator_units,attribute,unit_delimiter,reciprocal)
          
          if Unit.use_symbol_parentheses?
            if denominator_units.size > 1 && !numerator_string.empty?
              denominator_string = "(#{denominator_string.strip})"
            end
          end
        end

        string = numerator_string
        
        if (!denominator_string.empty? && !numerator_string.empty?) ||
            (!denominator_string.empty? && numerator_string.empty? && attribute == :name)
          string << denominator_delimiter
        end
        string << denominator_string
        
        return string.strip
      end

    end
  end
end
