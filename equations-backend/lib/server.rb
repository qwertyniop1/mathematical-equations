require 'sinatra'
require 'sinatra/namespace'

require_relative 'multi_route'
require_relative 'equations'
require_relative 'user'
require_relative 'api_description'

set port: 8080

helpers do
  def errors
    @errors ||= {}
  end

  def raise_if_error!(status_code = 400)
    halt status_code, { errors: errors }.to_json unless errors.empty?
  end

  def raise_error!(key, message, status_code = 400)
    errors[key] = message
    raise_if_error! status_code
  end

  def get_validated_data!(source, *args)
    float_regexp = /^-?\d+(?:\.\d+)?$/
    required_message = 'This parameter is required.'
    invalid_value_message = 'Parameter value is invalid.'

    # Symbolize keys
    parameters = source.inject({}) { |memo, (k, v)| memo[k.to_sym] = v; memo }
    validated_parameters = []

    args.each do |parameter|
      if parameters[parameter].nil?
        errors[parameter] = required_message
      else
        validated_parameters << parameters[parameter]
      end
    end

    raise_if_error!

    validated_parameters.each_with_index do |value, index|
      next if value.is_a? Numeric
      errors[args[index]] = invalid_value_message unless value.match? float_regexp
    end

    raise_if_error! 422

    validated_parameters.map(&:to_f)
  end

  def get_validated_params!(*args)
    get_validated_data! params, *args
  end

  def json_params
    JSON.parse request.body.read
  rescue
    raise_error! :request, 'Invalid request body.'
  end

  def authenticate?
    token = env['HTTP_AUTHORIZATION']
    !!User.where(token: token).first
  end
end

register do
  def check(name)
    condition do
      raise_error!(
        :authentication,
        'Missing or invalid authentication token',
        401) unless send(name)
    end
  end
end

get ['/', '/api'] do
  redirect '/api/v1'
end

not_found do
  raise_error! :details, 'Not found.', 404
end

namespace '/api/v1' do
  register Sinatra::MultiRoute

  before do
    content_type 'application/json'
  end

  route %i[get options] do
    api_description
  end

  options '/linear' do
    api_description :linear
  end

  get '/linear' do
    @coefficients = get_validated_params!(
      :coefficient_a,
      :coefficient_b
    )
    pass
  end

  post '/linear' do
    @coefficients = get_validated_data!(
      json_params,
      :coefficient_a,
      :coefficient_b
    )
    pass
  end

  get_or_post '/linear', check: :authenticate? do
    begin
      solution = LinearEquation.new(*@coefficients).solve
    rescue ArgumentError
      raise_error! :coefficient_a, 'Cannot equals to zero.', 422
    end

    result = {
      input: {
        coefficient_a: @coefficients[0],
        coefficient_b: @coefficients[1]
      },
      solution: {
        root: solution
      }
    }

    response.body = result.to_json
  end

  options '/quadratic' do
    api_description :quadratic
  end

  get '/quadratic' do
    @coefficients = get_validated_params!(
      :coefficient_a,
      :coefficient_b,
      :coefficient_c
    )
    pass
  end

  post '/quadratic' do
    @coefficients = get_validated_data!(
      json_params,
      :coefficient_a,
      :coefficient_b,
      :coefficient_c
    )
    pass
  end

  get_or_post '/quadratic', check: :authenticate? do
    begin
      solution = QuadraticEquation.new(*@coefficients).solve
    rescue ArgumentError
      raise_error! :coefficient_a, 'Cannot equals to zero.', 422
    end

    result = {
      input: {
        coefficient_a: @coefficients[0],
        coefficient_b: @coefficients[1],
        coefficient_c: @coefficients[2]
      },
      solution: {
        roots: solution,
        quantity: solution.size
      }
    }

    response.body = result.to_json
  end
end
