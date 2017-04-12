class MissingAttributeError < StandardError
  def initialize(method, currency, attribute)
    super(
      "Can't call Currency.#{method} - currency '#{currency}' is missing "\
      "the attribute '#{attribute}'"
    )
  end
end

class UnknownCurrency < ArgumentError; end
