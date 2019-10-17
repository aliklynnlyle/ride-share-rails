require 'rails_helper'

RSpec.feature "Users::UserPasswordResets", type: :feature do
  let!(:user) { create :user, email: "user@example.com"}

  scenario "user receives a password reset link if a valid email is provided" do
    visit root_path
    expect(page).to have_text "Rideshare"
    click_link 'admin-login'
    expect(page).to have_text "Log in"
    click_link "Forgot your password?"
    expect(page).to have_selector('h2', text: 'Forgot your password?')
    fill_in "Email", :with => user.email
    click_button "Send me reset password instructions"
    expect(current_path).to eql(new_user_session_path)
    expect(page).to have_text "Log in"
  end

  scenario "error occurs if an invalid email is provided" do
    visit new_user_session_path
    click_link "Forgot your password?"
    expect(page).to have_selector('h2', text: 'Forgot your password?')
    fill_in "Email", :with => 'invalid_user@example.com'
    click_button "Send me reset password instructions"
    expect(current_path).to eql(user_password_path)
    expect(page).to have_text "Email not found"
  end
end
