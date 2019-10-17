# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Rides', type: :feature, js: true do
  include Features::SessionHelpers

  let!(:organization) { create :organization }
  let!(:organization_2) { create :organization, name: 'NC State' }
  let!(:admin) { create :user }
  let!(:rider) { create :rider, organization_id: admin.organization.id }
  let!(:ride){create(:ride, organization_id: admin.organization.id, rider_id: rider.id,
    driver_id: driver.id, start_location_id: location1.id, end_location_id: location1.id)}


      # create_table "rides", force: :cascade do |t|
      #   t.bigint "organization_id"
      #   t.bigint "rider_id"
      #   t.bigint "driver_id"
      #   t.datetime "pick_up_time"
      #   t.bigint "start_location_id"
      #   t.bigint "end_location_id"
      #   t.text "reason"
      #   t.string "status", default: "pending"
      #   t.datetime "created_at", null: false
      #   t.datetime "updated_at", null: false
      #   t.index ["driver_id"], name: "index_rides_on_driver_id"
      #   t.index ["end_location_id"], name: "index_rides_on_end_location_id"
      #   t.index ["organization_id"], name: "index_rides_on_organization_id"
      #   t.index ["rider_id"], name: "index_rides_on_rider_id"
      #   t.index ["start_location_id"], name: "index_rides_on_start_location_id"
      # end

    # pick_up_time { Date.today + 5.days }
    # reason {"Interview"}
    # status { "pending"}

  scenario 'log in as admin' do
    visit root_path
    click_link 'Login as Admin'
    expect(page).to have_text 'Log in'
    signin('user@example.com', 'password')
    expect(page).to have_text 'Welcome Admins!'
  end

  scenario 'attempt to login as admin with incorrect password' do
    visit root_path
    click_link 'Login as Admin'
    expect(page).to have_text 'Log in'
    signin('user@example.com', 'wrongpw')
    expect(page).to have_text 'Invalid Email or password.'
  end

  scenario 'when admin selects list of rides, check that all rides are in org 'do
    visit root_path
    click_link 'Login as Admin'
    expect(page).to have_text 'Log in'
    fill_in 'Email', with: admin.email
    fill_in 'Password', with: 'password'
    click_on 'Log in'
    expect(page).to have_text 'Welcome Admins!'
    click_link 'Rides'

    # click_link 'Riders'
    # click_link 'Show'
    # expect(page).to have_text 'Rider Information'
    # expect(page).to have_text 'Ubber'
    # expect(page).to have_text '919-999-8888'
    # expect(page).to have_text '800 Park Offices Dr'
    # expect(page).to have_text 'Interview'
  end
end
