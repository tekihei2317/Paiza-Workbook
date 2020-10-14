require 'rails_helper'

RSpec.feature 'Filters', type: :feature do
  Capybara.default_driver = :selenium_chrome_headless

  before do
    visit root_path
  end

  describe 'ランク' do
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

  describe '難易度' do
  end

  describe '解いた問題の非表示' do
  end
end
