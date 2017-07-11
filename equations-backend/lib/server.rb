require 'sinatra'
require 'sinatra/namespace'

get '/' do
  'Index page'
end

namespace '/api/v1' do
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

    def get_validated_data!(parameters, *args)
      float_regexp = /^-?\d+(?:\.\d+)?$/
      required_message = 'This parameter is required.'
      invalid_value_message = 'Parameter value is invalid.'

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
    coefficient_a, coefficient_b = get_validated_params!(
      :coefficient_a,
      :coefficient_b
    )

    "a = #{coefficient_a}, b = #{coefficient_b}"
  end

  post '/linear' do
    coefficient_a, coefficient_b = get_validated_data!(
      json_params,
      :coefficient_a,
      :coefficient_b
    )

    "a = #{coefficient_a}, b = #{coefficient_b}"
  end

  get '/quadratic' do
    coefficient_a, coefficient_b, coefficient_c = get_validated_params!(
      :coefficient_a,
      :coefficient_b,
      :coefficient_c
    )

    "a = #{coefficient_a}, b = #{coefficient_b}, c = #{coefficient_c}"
  end

  post '/quadratic' do
    coefficient_a, coefficient_b, coefficient_c = get_validated_data!(
      json_params,
      :coefficient_a,
      :coefficient_b,
      :coefficient_c
    )

    "a = #{coefficient_a}, b = #{coefficient_b}, c = #{coefficient_c}"
  end
end

