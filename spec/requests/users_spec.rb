require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'GET /users/profile' do
    context 'ログインしていない場合' do
      it 'ログインページにリダイレクトされる' do
        get users_profile_path
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'ログインしている場合' do
      before do
        @user = FactoryBot.create(:user)
        sign_in @user
      end

      it '正常なレスポンスを返す' do
        get users_profile_path
        expect(response).to have_http_status(:success)
      end

      it '名前とメールアドレスが表示される' do
        get users_profile_path
        expect(response.body).to include @user.name
        expect(response.body).to include @user.email
      end
    end
  end

  describe 'GET /users/progress' do
    context 'ログインしていない場合' do
      it '正常なレスポンスを返す' do
        get users_progress_path
        expect(response).to have_http_status(:redirect)
      end

      it 'ログインページにリダイレクトされる' do
        get users_progress_path
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'ログインしている場合' do
      before do
        @user = FactoryBot.create(:user)
        sign_in @user
      end

      it '正常なレスポンスを返す' do
        get users_progress_path
        expect(response).to have_http_status(:success)
      end

      it '進捗ページが表示される' do
        get users_progress_path
        expect(response.body).to include('table')
      end
    end
  end
end
