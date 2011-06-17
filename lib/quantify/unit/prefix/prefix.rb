
module Quantify
  module Unit
    module Prefix
  
      attr_accessor :prefixes

      @prefixes = []

      def self.load(prefix)
        @prefixes << prefix if prefix.is_a? Quantify::Unit::Prefix::Base
      end

      def self.unload(*unloaded_prefixes)
        [unloaded_prefixes].flatten.each do |unloaded_prefix|
          unloaded_prefix = Prefix.for(unloaded_prefix)
          @prefixes.delete_if { |unit| unit.label == unloaded_prefix.label }
        end
      end

      def self.prefixes
        @prefixes
      end    

      def self.for(name_or_symbol,collection=nil)
        return name_or_symbol.clone if name_or_symbol.is_a? Quantify::Unit::Prefix::Base
        if name_or_symbol.is_a? String or name_or_symbol.is_a? Symbol
          if prefix = (collection.nil? ? @prefixes : collection).find do |prefix|
             prefix.name == name_or_symbol.standardize.downcase or
             prefix.symbol == name_or_symbol.standardize
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
        @prefixes.select {|prefix| prefix.is_si_prefix? }
      end

      # This can be replicated by method missing approach, but explicit method provided
      # given importance in Unit #match (and #for) methods regexen
      #
      def self.non_si_prefixes
        @prefixes.select {|prefix| prefix.is_non_si_prefix? }
      end

      def self.method_missing(method, *args, &block)
        if method.to_s =~ /((si|non_si)_)?prefixes(_by_(name|symbol|label))?/
          if $2
            prefixes = Prefix.prefixes.select { |prefix| instance_eval("prefix.is_#{$2}_prefix?") }
          else
            prefixes = Prefix.prefixes
          end
          return_format = ( $4 ? $4.to_sym : nil )
          prefixes.map(&return_format)
        elsif prefix = self.for(method)
          return prefix
        else
          raise NoMethodError, "Undefined method `#{method}` for #{self}:#{self.class}"
        end
      end

    end
  end
end
