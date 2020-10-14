require 'rails_helper'

RSpec.feature 'Filters', type: :feature do
  Capybara.default_driver = :selenium_chrome_headless

  before do
    visit root_path
  end

  describe 'ランクでのフィルタ' do
    describe 'Dランク' do
      context 'チェックを外したとき' do
        it 'そのランクの問題が表示されなくなる' do
          uncheck 'D'
          problem_ids = all(:css, 'tr.problem > td:nth-child(1)')
          problem_ids.each do |problem_id|
            expect(problem_id).to_not have_text 'D'
          end
        end

        it '問題数がそのランクの問題数だけ減る' do
          num_of_rank_d = Problem.where(rank: 'D').count
          expect {
            uncheck 'D'
          }.to change { all(:css, 'tr.problem').count }.by(-num_of_rank_d)
        end
      end

      context 'チェックを戻したとき' do
        it 'そのランクの問題が再表示される' do
          uncheck 'D'

          rank_d_exists = false
          problem_ids = all(:css, 'tr.problem > td:nth-child(1)')

          problem_ids.each do |problem_id|
            id = problem_id.text
            rank_d_exists = rank_d_exists || id.include?('D')
          end

          expect(rank_d_exists).to_not eq true
        end

        it '問題数がそのランクの問題数だけ増える' do
          uncheck 'D'
          num_of_rank_d = Problem.where(rank: 'D').count
          expect {
            check 'D'
            sleep 1
          }.to change { all(:css, 'tr.problem').count }.by(num_of_rank_d)
        end
      end
    end
  end

  describe '難易度でのフィルタ' do
  end

  describe '解いた問題の非表示' do
    before do
      # ユーザーを作成する
      @user = FactoryBot.create(:user)
      FactoryBot.create(:solved, user_id: @user.id, problem_id: 200)
      FactoryBot.create(:solved, user_id: @user.id, problem_id: 300)
      # binding.pry

      # ログインする
      visit new_user_session_path
      fill_in 'E-mail', with: @user.email
      fill_in 'Password', with: @user.password
      click_button 'SIGN IN'
      expect(page).to have_current_path root_path
    end

    context 'チェックをつけたとき' do
      it '解いた問題数だけ表示される問題が減る' do
        solved_count = @user.solved_problems.count # 2
        expect {
          check '解いた問題を非表示にする'
          expect(page).to_not have_css 'tr.table-success'
        }.to change { all(:css, 'tr.problem').count }.by(-solved_count)
      end
    end

    context 'チェックを外したとき' do
      it '解いた問題数だけ表示される問題が増える' do
        solved_count = @user.solved_problems.count

        # まずはチェックを付ける
        check '解いた問題を非表示にする'
        expect(page).to_not have_css 'tr.table-success'

        # チェックを外す
        expect {
          uncheck '解いた問題を非表示にする'
          expect(page).to have_css 'tr.table-success'
        }.to change { all(:css, 'tr.problem').count }.by(solved_count)
      end
    end
  end
end
