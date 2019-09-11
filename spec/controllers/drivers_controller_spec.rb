# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DriversController, type: :controller do
  let!(:user) { create :user }
  let!(:driver) { create :driver, organization_id: user.organization.id }
  let!(:driver_outside_organization) { create :driver, email: 'adriver@gmail.com' }

  before do
    sign_in user
  end

  it 'reports an error if the phone number is the wrong length' do
    expect do
      test_response = post :create, params: {
        driver: {
          first_name: 'John',
          last_name: 'Doe',
          phone: '1234567',
          email: 'wasemail@this.com',
          password: 'password',
          password_confirmation: 'password'
        }
      }

      expect(flash[:error][0]).to match(/wrong length/)
      expect(test_response.response_code).to eq(200)
    end.not_to change(Driver, :count)
  end

  it 'creates a driver' do
    expect do
      test_response = post :create, params: {
        driver: {
          first_name: 'John',
          last_name: 'Doe',
          phone: '1234567891',
          email: 'wasemail@this.com',
          password: 'password',
          password_confirmation: 'password'
        }
      }

      expect(flash[:notice]).to match(/has been saved/)
      expect(test_response.response_code).to eq(302)
      expect(test_response).to redirect_to(Driver.last)
    end.to change(Driver, :count)
  end

  it 'updates a driver' do
    test_response = put :update, params: {
      id: driver.id,
      driver: {
        first_name: 'Lucy'
      }
    }

    driver.reload
    expect(driver.first_name).to eq('Lucy')
    expect(test_response.response_code).to eq(302)
    expect(test_response).to redirect_to(driver)
  end

  it 'fails to update a driver in a different organization than active user' do
      test_response = put :update, params: {
        id: driver_outside_organization.id,
        driver: {
          first_name: 'Sam'
        }
      }

      expect(driver_outside_organization.first_name).to_not eq('Sam')
      expect(test_response.response_code).to eq(302)
      expect(test_response).to redirect_to(drivers_path)
      expect(flash[:notice]).to match(/not authorized/)
  end

  it 'accepts application' do
    test_response = put :accept, params: {
      driver_id: driver.id }

      driver.reload
      expect(driver.application_state).to eq("approved")
      # expect(test_response.response_code).to eq(302)
      # expect(flash[:notice]).to match(/updated/)
      # expect(test_response).to redirect_to(driver)
  end

  # PLEASE IGNORE FOLLOWING COMMENTS AS I AM STILL WORKING OUT THE CODE.
  #
  # it 'rejects application' do
  #   test_response = put :update, params: {
  #     id: driver_outside_organization.id,
  #     driver: {
  #       first_name: 'Tim'
  #     }
  #   }
  #
  #   driver_outside_organization.reload
  #   expect(driver.first_name).to_not eq('Tim')
  #   expect(test_response.response_code).to eq(302)
  #   expect(flash[:notice]).to match(/not authorized/)
  #   expect(test_response).to redirect_to(drivers_path)
  # end
  #
  # it 'passes background check' do
  #   test_response = put :pass, params: {
  #     id: driver.id,
  #     driver: {
  #       first_name: 'Alex'
  #     }
  #   }
  #
  #   driver.reload
  #   expect(driver.first_name).to eq('Alex')
  #   expect(test_response.response_code).to eq(302)
  #   expect(flash[:notice]).to match(/updated/)
  #   expect(test_response).to redirect_to(driver)
  #
  # end

  # it 'fails background check' do #put
  #
  # end
  #
  # it 'deactivates a driver' do #put
  #
  # end
end