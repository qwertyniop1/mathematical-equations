require 'equations'

equations = [
  [5, 6, -1.2],
  [35, -8, 8 / 35.0],
  [-4, 70, 17.5],
  [5, 0, 0],
  [-1000, 1000, 1],
]

RSpec.describe LinearEquation, '#solve' do
  context 'with valid coefficients' do
    it 'should solve linear equation' do
      equations.each do |data|
        equation = LinearEquation.new(data[0], data[1])
        expect(equation.solve).to eq data[2]
      end
    end

    it 'should consider coefficient B to equals 0 by default' do
      equations.each do |data|
        equation = LinearEquation.new(data[0])
        expect(equation.solve).to eq 0
      end
    end

    it 'should pass random tests' do
      20.times do
        a, b = rand(1000) + 1, rand(1000) - 500
        equation = LinearEquation.new(a, b)
        root = equation.solve
        expect(a * root + b).to be_within(1e-10).of(0)
      end
    end

    it 'should pass random tests with float coefficients' do
      20.times do
        a, b = rand * 100 - 50, rand * 100 - 50
        equation = LinearEquation.new(a, b)
        root = equation.solve
        expect(a * root + b).to be_within(1e-10).of(0)
      end
    end
  end

  context 'with invalid coefficients' do
    it 'raises ArgumentError when coefficient A equals 0' do
      expect { LinearEquation.new(0) }.to raise_error(ArgumentError)
      expect { LinearEquation.new(0.0) }.to raise_error(ArgumentError)
    end
  end

  context 'with invalid arguments' do
    it 'raises ArgumentError when arguments are not numbers' do
      [
        ['0', 5],
        ['f', nil],
        [[]],
        [8, 'q'],
      ].each do |args|
        expect { LinearEquation.new(*args) }.to raise_error(ArgumentError)
      end
    end
  end
end
