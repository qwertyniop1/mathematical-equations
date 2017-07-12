class EquationsAPI
  include HTTParty
  base_uri 'lvh.me/api'

  def initialize(coefficients = {})
    @options = coefficients
  end

  def linear
    raise NotImplementedError
  end

  def quadratic
    raise NotImplementedError
  end
end
