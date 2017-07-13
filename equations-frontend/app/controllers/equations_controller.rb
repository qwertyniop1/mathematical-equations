require 'equations_api'

class EquationsController < ApplicationController
  def linear
  end

  def solve_linear
    @result = EquationsAPI.new(equation_params).linear

    respond_to do |format|
      format.js { render :solve_equation }
    end
  end

  def quadratic
  end

  def solve_quadratic
    @result = EquationsAPI.new(equation_params).quadratic

    respond_to do |format|
      format.js { render :solve_equation }
    end
  end

  private

  def equation_params(quadratic = false)
    required_params = [:coefficient_a, :coefficient_b]
    required_params << :coefficient_c if quadratic
    params.require(required_params)
  end
end
