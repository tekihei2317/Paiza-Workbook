require 'rails_helper'

RSpec.feature 'Accounts', type: :feature do
  # Capybara.default_driver = :selenium_chrome

  describe 'アカウント登録機能' do
    scenario '有効な属性の場合は登録できる' do
      user = FactoryBot.build(:user)

      visit new_user_registration_path

      expect {
        fill_in 'Username', with: user.name
        fill_in 'E-mail', with: user.email
        fill_in 'Password', with: user.password
        fill_in 'Password Confirmation', with: user.password
        click_button 'SIGN UP'
      }.to change(User, :count).by(1)

      # 問題一覧画面にリダイレクトされる
      expect(page).to have_current_path root_path
      expect(page).to have_content 'アカウント登録が完了しました'
    end

    scenario '無効な属性の場合は登録できない' do
      user = FactoryBot.build(:user, :invalid_password)

      visit new_user_registration_path

      expect {
        fill_in 'Username', with: user.name
        fill_in 'E-mail', with: user.email
        fill_in 'Password', with: user.password
        fill_in 'Password Confirmation', with: user.password
        click_button 'SIGN UP'
      }.to_not change(User, :count)

      # リダイレクトされない
      expect(page).to_not have_current_path root_path
    end
  end

  describe 'ログイン機能' do
    scenario 'メールアドレスでログインすることができる' do
      user = FactoryBot.create(:user)

      visit root_path
      click_link 'login'
      expect(page).to have_current_path new_user_session_path

      fill_in 'E-mail', with: user.email
      fill_in 'Password', with: user.password
      click_button 'SIGN IN'

      expect(page).to have_current_path root_path
      expect(page).to have_content 'ログインしました'
    end
  end

  describe 'ログアウト機能' do
    before do
      user = FactoryBot.create(:user)
      visit new_user_session_path
      fill_in 'E-mail', with: user.email
      fill_in 'Password', with: user.password
      click_button 'SIGN IN'
    end

    scenario 'ログアウトすることができる' do
      # トーストをクリックして消す
      find(:css, 'div.toast').click
      click_link 'logout'
      expect(page).to have_content 'ログアウトしました'
    end
  end
end
