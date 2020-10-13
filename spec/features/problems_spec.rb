require 'rails_helper'

RSpec.feature 'Problems', type: :feature do
  scenario 'ユーザーはログイン出来る' do
    user = FactoryBot.create(:user)

    visit root_path
    click_link 'login'
    expect(page).to have_current_path new_user_session_path

    fill_in 'E-mail', with: user.email
    fill_in 'Password', with: user.password
    click_button 'SIGN IN'
    expect(page).to have_current_path root_path
  end
end
