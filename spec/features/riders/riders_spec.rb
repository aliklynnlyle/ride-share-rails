# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Riders', type: :feature, js: true do
  include Features::SessionHelpers

  let!(:organization) { create :organization }
  let!(:admin) { create :user }
  let!(:rider) { create :rider, organization_id: admin.organization.id }
  let!(:rider_outside_organization) { create :rider, email: 'arider@gmail.com', first_name: 'Joey' }
  let!(:location) { create :location }
  let!(:location1) { create :location, street: "100 Main St", city: 'Durham', state: "NC", zip: "27713" }
  let!(:ride){create(:ride, rider_id: rider.id, organization_id: admin.organization.id,
    start_location_id: location1.id, end_location_id: location1.id)}
  let!(:location_relationship) { create :location_relationship, rider_id: rider.id, location_id: location.id }

  scenario 'when admin selects list of riders, check that all riders are in org 'do
    visit root_path
    click_link 'Login as Admin'
    expect(page).to have_text 'Log in'
    fill_in 'Email', with: admin.email
    fill_in 'Password', with: 'password'
    click_on 'Log in'
    expect(page).to have_text "Welcome #{admin.email}!"
    click_link 'Riders'
    expect(page).to have_text rider.first_name
    expect(page).not_to have_text rider_outside_organization.first_name
  end

  scenario 'when admin clicks show, fields should be populated' do
    visit root_path
    click_link 'Login as Admin'
    expect(page).to have_text 'Log in'
    signin('user@example.com', 'password')
    expect(page).to have_text 'Welcome user@example.com!'
    click_link 'Riders'
    click_link 'Show'
    expect(page).to have_text 'Rider Information'
    expect(page).to have_text 'Ubber'
    expect(page).to have_text '919-999-8888'
    expect(page).to have_text '800 Park Offices Dr'
    expect(page).to have_text 'Interview'
  end
end
