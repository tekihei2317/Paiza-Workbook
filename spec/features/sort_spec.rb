require 'rails_helper'

RSpec.feature 'Sorts', type: :feature do
  Capybara.default_driver = :selenium_chrome_headless

  describe '問題IDでのソート' do
    before do
      @problem_with_smallest_id = Problem.order(:rank, :number).first
      @problem_with_largest_id = Problem.order(:rank, :number).last

      visit root_path
      @button = find('th', text: '問題ID')
    end

    it '一度クリックすると降順になる' do
      @button.click
      sleep 0.5

      first_problem = first(:css, 'tr.problem > td:nth-child(2)')
      expect(first_problem.text).to eq @problem_with_largest_id.name
    end

    it '二度クリックすると昇順になる' do
      @button.click
      @button.click
      sleep 0.5

      first_problem = first(:css, 'tr.problem > td:nth-child(2)')
      expect(first_problem.text).to eq @problem_with_smallest_id.name
    end
  end

  describe '難易度でのソート' do
    before do
      @problem_with_smallest_difficulty = Problem.order(:difficulty).first
      @problem_with_largest_difficulty = Problem.order(:difficulty).last

      visit root_path
      @button = find('th', text: '難易度')
    end

    it '一度クリックすると昇順になる' do
      @button.click
      sleep 0.5

      first_problem = first(:css, 'tr.problem > td:nth-child(2)')
      expect(first_problem.text).to eq @problem_with_smallest_difficulty.name
    end

    it '二度クリックすると降順になる' do
      @button.click
      @button.click
      sleep 0.5

      first_problem = first(:css, 'tr.problem > td:nth-child(2)')
      expect(first_problem.text).to eq @problem_with_largest_difficulty.name
    end
  end

  describe '正解率でのソート' do
    before do
      @problem_with_smallest_ac_rate = Problem.order(:acceptance_rate).first
      @problem_with_largest_ac_rate = Problem.order(:acceptance_rate).last

      visit root_path
      @button = find('th', text: '正解率')
    end

    it '一度クリックすると降順になる' do
      @button.click
      sleep 0.5

      first_problem = first(:css, 'tr.problem > td:nth-child(2)')
      expect(first_problem.text).to eq @problem_with_largest_ac_rate.name
    end

    it '二度クリックすると昇順になる' do
      @button.click
      @button.click
      sleep 0.5

      first_problem = first(:css, 'tr.problem > td:nth-child(2)')
      expect(first_problem.text).to eq @problem_with_smallest_ac_rate.name
    end
  end

  describe '平均スコアでのソート' do
    before do
      @problem_with_smallest_avg_score = Problem.order(:average_score).first
      @problem_with_largest_avg_score = Problem.order(:average_score).last

      visit root_path
      @button = find('th', text: '平均スコア')
    end

    it '一度クリックすると降順になる' do
      @button.click
      sleep 0.5

      first_problem = first(:css, 'tr.problem > td:nth-child(2)')
      expect(first_problem.text).to eq @problem_with_largest_avg_score.name
    end

    it '二度クリックすると昇順になる' do
      @button.click
      @button.click
      sleep 0.5

      first_problem = first(:css, 'tr.problem > td:nth-child(2)')
      expect(first_problem.text).to eq @problem_with_smallest_avg_score.name
    end
  end
end
