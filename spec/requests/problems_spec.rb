require 'rails_helper'

RSpec.describe 'Problems', type: :request do
  describe 'GET /' do
    it '正常なレスポンスを返す' do
      get root_path
      # binding.pry
      expect(response).to be_success
      expect(response).to have_http_status '200'
    end
  end

  describe 'POST /problems/filter' do
    it '正常なレスポンスを返す' do
      post problems_filter_path
      expect(response).to have_http_status(:success)
    end

    it '送信パラメーターが正しくJSONに変換される' do
      post problems_filter_path,
           params: {
             rank_d: '1',
             rank_c: '1',
             difficulty_min: '1000',
             difficulty_max: '1600',
           }

      query = JSON.parse(response.body, symbolize_names: true)
      expected_query = {
        rank: { d: true, c: true, b: false, a: false, s: false },
        difficulty: { min: 1000, max: 1600 },
        hideSolved: false,
      }
      expect(query).to eq expected_query
    end
  end
end
