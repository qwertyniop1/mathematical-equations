require 'sinatra'
require 'sinatra/namespace'

module Sinatra
  module MultiRoute
    def get_or_post(url, options = {}, &block)
      get(url, &block)
      post(url, &block)
    end
  end
end

require_relative 'equations'

get '/' do
  'Index page'
end

namespace '/api/v1' do
  register Sinatra::MultiRoute

  before do
    content_type 'application/json'
  end

  helpers do
    def errors
      @errors ||= {}
    end

    def raise_if_error!(code = 400)
      halt code, { errors: errors }.to_json unless errors.empty?
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
      errors[:request] = 'Invalid request body.'
      raise_if_error!
    end
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

  get_or_post '/linear' do
    begin
      solution = LinearEquation.new(*@coefficients).solve
    rescue ArgumentError
      errors[:coefficient_a] = 'Cannot equals to zero.'
      raise_if_error! 422
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

  get_or_post '/quadratic' do
    begin
      solution = QuadraticEquation.new(*@coefficients).solve
    rescue ArgumentError
      errors[:coefficient_a] = 'Cannot equals to zero.'
      raise_if_error! 422
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
