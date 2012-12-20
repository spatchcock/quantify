
module Quantify
  module Unit
    module Prefix
  
      attr_accessor :prefixes

      @prefixes = []
      @si_prefixes = []
      @non_si_prefixes = []


      def self.load(prefix)
        @prefixes << prefix if prefix.is_a? Quantify::Unit::Prefix::Base
        @si_prefixes << prefix if prefix.is_si_prefix?
        @non_si_prefixes << prefix if prefix.is_non_si_prefix?
      end

      def self.unload(*unloaded_prefixes)
        [unloaded_prefixes].flatten.each do |unloaded_prefix|
          unloaded_prefix = Prefix.for(unloaded_prefix)
          @prefixes.delete_if { |prefix| prefix.label == unloaded_prefix.label }
          @si_prefixes.delete_if { |prefix| prefix.label == unloaded_prefix.label }
          @non_si_prefixes.delete_if { |prefix| prefix.label == unloaded_prefix.label }
        end
      end

      def self.prefixes
        @prefixes
      end    

      def self.for(name_or_symbol)
        return name_or_symbol.clone if name_or_symbol.is_a? Quantify::Unit::Prefix::Base
        if name_or_symbol.is_a?(String) || name_or_symbol.is_a?(Symbol)
          if prefix = @prefixes.find do |prefix|
             prefix.name == name_or_symbol.remove_underscores.downcase ||
             prefix.symbol == name_or_symbol.remove_underscores
            end
            return prefix.clone
          else
            return nil
          end
        else
          raise Exceptions::InvalidArgumentError, "Argument must be a Symbol or String"
        end
      end

      # This can be replicated by method missing approach, but explicit method provided
      # given importance in Unit #match (and #for) methods regexen
      #
      def self.si_prefixes
        @si_prefixes
      end

      # This can be replicated by method missing approach, but explicit method provided
      # given importance in Unit #match (and #for) methods regexen
      #
      def self.non_si_prefixes
        @non_si_prefixes
      end

      def self.method_missing(method, *args, &block)
        if method.to_s =~ /((si|non_si)_)?prefixes(_by_(name|symbol|label))?/
          if $2
            prefixes = Prefix.prefixes.select { |prefix| instance_eval("prefix.is_#{$2}_prefix?") }
          else
            prefixes = Prefix.prefixes
          end
          return_format = ( $4 ? $4.to_sym : nil )
          prefixes.map(&return_format).to_a
        elsif prefix = self.for(method)
          return prefix
        else
          super
        end
      end

    end
  end
end
