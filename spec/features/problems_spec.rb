require 'rails_helper'

RSpec.feature 'Problems', type: :feature, js: true do
  scenario '問題が全問表示されている' do
    visit root_path
    problems = all(:css, 'tr.problem')
    expect(problems.count).to eq Problem.count
  end
end
