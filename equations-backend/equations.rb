module Validation
  def numeric_attr(*args)
    args.each do |name|
      define_method(name) do
        instance_variable_get "@#{name}"
      end

      define_method("#{name}=") do |value|
        raise ArgumentError, 'Value should be numeric' unless value.is_a? Numeric
        instance_variable_set("@#{name}", value.to_f)
      end
    end
  end

  def check_arguments!(*args)
    args.each do |value|
      raise ArgumentError, 'Value should be numeric' unless value.is_a? Numeric
    end
  end
end

class Equation
  extend Validation

  EPS = 1e-12

  def initialize
    raise NotImplemetedError('Cannot create instance of an abstract class')
  end

  def solve
    raise NotImplemetedError('Cannot execute method of an abstract class')
  end

  def zero?(number)
    number.abs < EPS
  end
end

class LinearEquation < Equation
  numeric_attr :coefficient_a, :coefficient_b

  def initialize(a, b = 0)
    raise ArgumentError, 'Coefficient A cannot equals to zero' if a.zero?
    self.class.check_arguments! a, b
    @coefficient_a = a.to_f
    @coefficient_b = b.to_f
  end

  def solve
    -@coefficient_b / @coefficient_a
  end
end

class QuadraticEquation < Equation
  numeric_attr :coefficient_a, :coefficient_b, :coefficient_c

  def initialize(a, b = 0, c = 0)
    raise ArgumentError, 'Coefficient A cannot equals to zero' if a.zero?
    self.class.check_arguments! a, b, c
    @coefficient_a = a.to_f
    @coefficient_b = b.to_f
    @coefficient_c = c.to_f
  end

  def solve
    discriminant = @coefficient_b**2 - 4 * @coefficient_a * @coefficient_c
    return nil if discriminant.negative?
    return -@coefficient_b / (2 * @coefficient_a) if zero? discriminant

    sqrt_discriminant = Math.sqrt(discriminant)
    first_root = (-@coefficient_b + sqrt_discriminant) / (2 * @coefficient_a)
    second_root = (-@coefficient_b - sqrt_discriminant) / (2 * @coefficient_a)
    [first_root, second_root]
  end
end
