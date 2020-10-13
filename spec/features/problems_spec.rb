require 'rails_helper'

RSpec.feature 'Problems', type: :feature, js: true do
  # scenario 'ユーザーはログイン出来る' do
  # user = FactoryBot.create(:user)
  #
  # visit root_path
  # click_link 'login'tr
  # expect(page).to have_current_path new_user_session_path
  #
  # fill_in 'E-mail', with: user.email
  # fill_in 'Password', with: user.password
  # click_button 'SIGN IN'
  # expect(page).to have_current_path root_path
  # end
  #
  # scenario 'ユーザーが問題IDでソートする' do
  # visit root_path
  # click '問題ID'
  # end

  scenario 'ユーザーがDランクのチェックボックスを操作する' do
    user = FactoryBot.create(:user)

    visit root_path
    click_link 'login'
    expect(page).to have_current_path new_user_session_path

    fill_in 'E-mail', with: user.email
    fill_in 'Password', with: user.password
    click_button 'SIGN IN'
    expect(page).to have_current_path root_path

    binding.pry
    uncheck 'rank_d'
    binding.pry
  end
end
