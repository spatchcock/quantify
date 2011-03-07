
module Quantify

  module Prefix

    attr_accessor :prefixes

    @prefixes = []

    def self.load(prefix)
      @prefixes << prefix if prefix.is_a? Quantify::Prefix::Base
    end
    
    def self.prefixes
      @prefixes
    end

    def self.si_prefixes
      @prefixes.select { |prefix| prefix.is_si? }
    end

    def self.non_si_prefixes
      @prefixes.select { |prefix| !prefix.is_si? }
    end

    def self.names
      @prefixes.map { |prefix| prefix.name  }
    end

    def self.si_names
      si_prefixes.map { |prefix| prefix.name }
    end

    def self.non_si_names
      non_si_prefixes.map { |prefix| prefix.name }
    end

    def self.symbols
      @prefixes.map { |prefix| prefix.symbol }
    end

    def self.si_symbols
      si_prefixes.map { |prefix| prefix.symbol }
    end

    def self.non_si_symbols
      non_si_prefixes.map { |prefix| prefix.symbol }
    end

    def self.for(name_or_symbol)
      if name_or_symbol.is_a? String or name_or_symbol.is_a? Symbol
        if prefix = @prefixes.find do |prefix|
           prefix.name == name_or_symbol.standardize.downcase or
           prefix.symbol == name_or_symbol.standardize
          end
          return prefix.clone
        else
          return nil
        end
      else
        raise InvalidArgumentError, "Argument must be a Symbol or String"
      end
    end

    def self.method_missing(method, *args, &block)
      if prefix = self.for(method)
        return prefix
      else
        raise NoMethodError, "Undefined method `#{method}` for #{self}:#{self.class}"
      end
    end

    class Base

      def self.load(options)
        if options.is_a? Hash
          Prefix.prefixes << self.new(options)
        end
      end

      def self.configure &block
        class_eval &block
      end

      attr_reader :name, :symbol, :factor

      def initialize(options)
        @symbol = options[:symbol].standardize
        @factor = options[:factor].to_f
        @name = options[:name].standardize.downcase
      end

      def is_si?
        self.is_a? SI
      end

    end

    class SI < Base; end

    class NonSI < Base; end

  end
end
