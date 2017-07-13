require 'rails_helper'

RSpec.describe 'EquationPages', type: :request do

  subject { page }

  describe 'Linear equations page' do
  	before { visit linear_path }

    it { should have_title 'Linear equations | Equations Solver' }
    it { should have_selector 'h2', text: 'Linear equation' }
    it { should have_selector 'form' }

    describe 'submitimg' do
      context 'with valid parameters' do
        before do
          fill_in 'coefficient_a', with: '5'
          fill_in 'coefficient_b', with: '-20'
          click_button 'Solve'
        end

        it 'should preview the expression' do
          expect(page).to have_selector 'div', text: '`5x-20=0`'
        end

        it 'should display solution' do
          expect(page).to have_selector 'div', text: '4'
        end
      end

      context 'with coefficient A equals to 0' do
        before do
          fill_in 'coefficient_a', with: '0'
          fill_in 'coefficient_b', with: '-20'
          click_button 'Solve'
        end

        it 'should display error message' do
          expect(page).to have_selector '.equation__error', text: 'Coefficient A cannot equals to 0.'
        end
      end
    end
  end

  describe 'Quadratic equations page' do
  	before { visit quadratic_path }

    it { should have_title 'Quadratic equations | Equations Solver' }
    it { should have_selector 'h2', text: 'Quadratic equation' }
    it { should have_selector 'form' }

    describe 'submitimg' do
      context 'with valid parameters' do

        before do
          fill_in 'coefficient_a', with: '1'
          fill_in 'coefficient_b', with: '-10'
          fill_in 'coefficient_b', with: '25'
          click_button 'Solve'
        end

        it 'should preview the expression' do
          expect(page).to have_selector 'div', text: '`x^2-10x+25=0`'
        end

        it 'should display solution' do
          expect(page).to have_selector 'div', text: '5'
        end
      end
    end

    context 'with coefficient A equals to 0' do
      before do
        fill_in 'coefficient_a', with: '0'
        fill_in 'coefficient_b', with: '-20'
        click_button 'Solve'
      end

      it 'should display error message' do
        expect(page).to have_selector '.equation__error', text: 'Coefficient A cannot equals to 0.'
      end
    end

  end

end
