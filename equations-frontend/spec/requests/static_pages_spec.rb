require 'rails_helper'

RSpec.describe 'StaticPages', type: :request do

  subject { page }

  shared_examples_for 'all static pages' do
    it { should have_selector('li.active', text: heading) }
    it { should have_title(full_title page_title) }
  end

  describe 'Home Page' do
    before { visit root_path}
    let(:heading) { 'Equations Solver' }
    let(:page_title) { '' }

    it { should_not have_title ' | Home' }
    it_should_behave_like 'all static pages'
  end

  describe 'About page' do
    before { visit about_path}
    let(:heading) { 'About' }
    let(:page_title) { 'About' }

    it { should have_selector 'p', text: 'Contacts' }
    it_should_behave_like 'all static pages'
  end

  describe 'Api page' do
    before { visit api_path}
    let(:heading) { 'Api' }
    let(:page_title) { 'Developers' }

    it { should have_selector 'table' }
    it_should_behave_like 'all static pages'
  end

  it 'should have the right links on the layout' do
    visit root_path
    click_link 'Equations Solver'
    expect(page).to have_title(full_title '')
    click_link 'About'
    expect(page).to have_title(full_title 'About')
    click_link 'Api'
    expect(page).to have_title(full_title 'Developers')
    click_link 'Linear'
    expect(page).to have_title(full_title 'Linear equations')
    click_link 'Quadratic'
    expect(page).to have_title(full_title 'Quadratic equations')
    # click_link 'Sign up'
    # expect(page).to have_title(full_title 'Sign up')
    # click_link 'Sign in'
    # expect(page).to have_title(full_title 'Sign in')
  end
end
