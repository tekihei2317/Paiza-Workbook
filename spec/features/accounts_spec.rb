require 'rails_helper'

RSpec.feature 'Accounts', type: :feature do
  Capybara.default_driver = :selenium_chrome

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

  describe 'ユーザー編集機能' do
    before do
      @user = FactoryBot.create(:user)
      visit new_user_session_path
      fill_in 'E-mail', with: @user.email
      fill_in 'Password', with: @user.password
      click_button 'SIGN IN'

      # トーストをクリックして消す
      find(:css, 'div.toast').click
    end

    scenario '有効な情報のとき更新できる' do
      click_link 'profile'
      click_link '編集する'

      # フォームの中身を削除する
      fill_in 'user_name', with: ''
      fill_in 'user_email', with: ''

      fill_in 'user_name', with: 'Bob'
      fill_in 'user_email', with: 'bob@example.com'
      click_button '更新する'

      # 編集ページにリダイレクトされることを確認する
      expect(page).to have_current_path users_profile_path
      expect(page).to have_content 'アカウント情報を変更しました'

      # 更新されていることを確認する
      expect(page).to have_content 'Bob'
      expect(page).to have_content 'bob@example.com'

      expect(@user.name).to eq 'Alice'
      expect(@user.reload.name).to eq 'Bob'
      expect(@user.email).to eq 'bob@example.com'
    end

    scenario '無効な情報のとき更新できない' do
      click_link 'profile'
      click_link '編集する'

      # フォームの中身を削除する
      fill_in 'user_name', with: ''
      fill_in 'user_email', with: ''

      # 空のまま送信する
      click_button '更新する'

      # リダイレクトされないことを確認する
      expect(page).to have_content 'アカウントを削除する'

      # 更新されていないことを確認する
      expect(@user.reload.name).to eq 'Alice'
    end
  end

  describe 'アカウント削除機能' do
    before do
      @user = FactoryBot.create(:user)
      visit new_user_session_path
      fill_in 'E-mail', with: @user.email
      fill_in 'Password', with: @user.password
      click_button 'SIGN IN'

      # トーストをクリックして消す
      find(:css, 'div.toast').click
    end

    scenario 'アカウントを削除することが出来る' do
      click_link 'profile'
      click_link '編集する'

      expect {
        click_link 'アカウントを削除する'

        # Rask::TestではJavaScriptが動作しないので、ダイアログは出ないみたい
        # https://ja.stackoverflow.com/questions/66340/rspec%E3%81%A7confirm%E3%83%80%E3%82%A4%E3%82%A2%E3%83%AD%E3%82%B0%E3%81%AE%E3%83%86%E3%82%B9%E3%83%88%E3%81%8C%E9%80%9A%E3%82%89%E3%81%AA%E3%81%84
        page.accept_confirm

        expect(page).to have_content 'アカウントを削除しました'
      }.to change(User, :count).by(-1)
    end
  end
end
