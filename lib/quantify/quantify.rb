module Quantify

  class << self
    attr_accessor :prevailing_unit_rules
  end

  def self.configure &block
    self.module_eval &block if block
  end

  def self.describe_prevailing_unit_rules &block
    @prevailing_unit_rules = block
  end
end