
ActiveSupport::Inflector.inflections do |inflect|

  inflect.plural /(metre)/i, '\1s'
  inflect.singular /(metre)s?/i, '\1'

  inflect.plural /(degree)/i, '\1s'
  inflect.singular /(degree)s?/i, '\1'

  inflect.plural /(barrel)/i, '\1s'
  inflect.singular /(barrel)s?/i, '\1'

  inflect.plural /(unit)/i, '\1s'
  inflect.singular /(unit)s?/i, '\1'

  inflect.plural /(ounce)/i, '\1s'
  inflect.singular /(ounce)s?/i, '\1'

  inflect.plural /(volt)/i, '\1s'
  inflect.singular /(volt)s?/i, '\1'

  inflect.plural /(foot)/i, 'feet'
  inflect.singular /(feet)/i, 'foot'

  inflect.plural /(gallon)/i, '\1s'
  inflect.singular /(gallon)s?/i, '\1'

  # 'uncountable' but required regex inflection definition for cases where combined with prefix
  inflect.plural /(horsepower)/i, '\1'
  inflect.singular /(horsepower)/i, '\1'

  # 'uncountable' but required regex inflection definition for cases where combined with prefix
  inflect.plural /(hundredweight)/i, '\1'
  inflect.singular /(hundredweight)/i, '\1'

  inflect.plural /(inch)/i, '\1es'
  inflect.singular /(inch)(es)?/i, '\1'

  inflect.plural /(league)/i, '\1s'
  inflect.singular /(league)s?/i, '\1'

  inflect.plural /(mass)/i, '\1es'
  inflect.singular /(mass)(es)?/i, '\1'

  inflect.plural /(mile)/i, '\1s'
  inflect.singular /(mile)s?/i, '\1'

  inflect.plural /(pound)/i, '\1s'
  inflect.singular /(pound)s?/i, '\1'

  # This inflection is defined after that of 'pound' so that 'pound mole' is inflected appropriately
  inflect.plural /(mole)/i, '\1s'
  inflect.singular /(mole)s?/i, '\1'
  
  inflect.plural /(ton)/i, '\1s'
  inflect.singular /(ton)s?/i, '\1'

  inflect.plural /(tonne)/i, '\1s'
  inflect.singular /(tonne)s?/i, '\1'

  inflect.plural /(stone)/i, '\1s'
  inflect.singular /(stone)s?/i, '\1'
  
  # 'uncountable' but required regex inflection definition for cases where combined with prefix
  inflect.plural /(gauss)/i, '\1'
  inflect.singular /(gauss)/i, '\1'

  # 'uncountable' but required regex inflection definition for cases where combined with prefix
  inflect.plural /(clo)/i, '\1'
  inflect.singular /(clo)/i, '\1'

  # 'uncountable' but required regex inflection definition for cases where combined with prefix
  inflect.plural /(hertz)/i, '\1'
  inflect.singular /(hertz)/i, '\1'
  
  # 'uncountable' but required regex inflection definition for cases where combined with prefix
  inflect.plural /(lux)/i, '\1'
  inflect.singular /(lux)/i, '\1'
  
  # 'uncountable' but required regex inflection definition for cases where combined with prefix
  inflect.plural /(siemens)/i, '\1'
  inflect.singular /(siemens)/i, '\1'
  
  inflect.irregular 'footcandle', 'footcandles'
  inflect.irregular 'kilowatt hour', 'kilowatt hours'

end
