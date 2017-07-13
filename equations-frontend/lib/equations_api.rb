class EquationsAPI
  include HTTParty
  base_uri 'lvh.me:8080'

  def initialize(coefficients = {})
    @options = { query: coefficients }
  end

  def linear
    get_request('linear')
  end

  def quadratic
    get_request('quadratic')
  end

  private

  def get_request(equation_type)
    response = self.class.get("/api/v1/#{equation_type}", @options)
    return nil unless response.ok?

    solution = JSON.parse(response.body)
    if solution['solution']['root']
      [solution['solution']['root']]
    else
      solution['solution']['roots']
    end
  end
end
