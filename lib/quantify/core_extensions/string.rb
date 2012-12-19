# encoding: UTF-8
class String

  def with_superscript_characters
    self.gsub!(/\^2\b/,"²")
    self.gsub!(/\^3\b/,"³")
    self
  end

  def without_superscript_characters
    self.gsub!(/¹\b/,"")
    self.gsub!(/²\b/,"^2")
    self.gsub!(/³\b/,"^3")
    self
  end
  
  def remove_underscores
    self.gsub!("_"," ")
    self
  end

  def words
    split(/\s+/)
  end

  def word_count
    words.size
  end

  def starts_with_number?
    (/\A#{Unit::NUMBER_REGEX}/i).match(self) ? true : false
  end
  
  def starts_with_valid_unit_term?
    return false unless 
    term = /\A#{Unit.unit_label_regex}#{Unit::INDEX_REGEX}?/.match(self)  || 
           /\A#{Unit.unit_symbol_regex}#{Unit::INDEX_REGEX}?/.match(self) || 
           /\A#{Unit.unit_name_regex}#{Unit::INDEX_REGEX}?/.match(self)   || 
           /\A#{Unit::UNIT_DENOMINATOR_REGEX}/.match(self)                || 
           /\A(#{Unit::UNIT_PREFIX_TERMS_REGEX}|#{Unit::UNIT_SUFFIX_TERMS_REGEX})/i.match(self) 
           
    return term[0]
  end

  def to_quantity
    Quantify::Quantity.parse(self)
  end
  alias :to_q :to_quantity

end
