require 'equations'

equations = [
  [[1, -6, 8], [2, 4]],
  [[5, -12, 4], [0.4, 2]],
  [[1, -12, 36], [6]],
  [[3, 8, 13], []],
  [[-5, 0, 20], [-2, 2]],
  [[5, 10], [-2, 0]],
]

RSpec.describe QuadraticEquation, '#solve' do
  context 'with valid coefficients' do
    it 'should solve quadratic equation' do
      equations.each do |data|
        equation = QuadraticEquation.new(*data[0])
        expect(equation.solve.sort).to eq data[1]
      end
    end

    it 'should consider coefficient B and C to equals 0 by default' do
      equation = QuadraticEquation.new(1)
      expect(equation.coefficient_b).to eq 0
      expect(equation.coefficient_c).to eq 0

      equation = QuadraticEquation.new(1, 1)
      expect(equation.coefficient_c).to eq 0
    end

    it 'should pass random tests' do
      20.times do
        a, b, c = rand(1000) + 1, rand(1000) - 500, rand(1000)
        equation = QuadraticEquation.new(a, b, c)
        roots = equation.solve
        if (b**2 - 4 * a * c).abs > 1e-10
          roots.each do |root|
            expect(a * root**2 + b * root + c).to be_within(1e-10).of(0)
          end
        else
          expect(roots.size).to be_empty
        end
      end
    end

    it 'should pass random tests with float coefficients' do
      20.times do
        a, b, c = rand * 100 - 50, rand * 100 - 50, rand(100)
        equation = QuadraticEquation.new(a, b, c)
        roots = equation.solve
        if (b**2 - 4 * a * c).abs > 1e-10
          roots.each do |root|
            expect(a * root**2 + b * root + c).to be_within(1e-10).of(0)
          end
        else
          expect(roots.size).to be_empty
        end
      end
    end
  end

  context 'with invalid coefficients' do
    it 'raises ArgumentError when coefficient A equals 0' do
      expect { QuadraticEquation.new(0) }.to raise_error(ArgumentError)
      expect { QuadraticEquation.new(0.0) }.to raise_error(ArgumentError)
    end
  end

  context 'with invalid arguments' do
    it 'raises ArgumentError when arguments are not numbers' do
      [
        ['0', 5],
        ['f', nil],
        [[]],
        [8, 'q'],
        [8, 4, 'q'],
      ].each do |args|
        expect { QuadraticEquation.new(*args) }.to raise_error(ArgumentError)
      end
    end
  end
end
