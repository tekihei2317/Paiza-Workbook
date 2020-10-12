require 'rails_helper'

RSpec.describe Problem, type: :model do
  it 'ランク、問題番号、問題名、URL、難易度があれば有効である' do
    problem = Problem.new(
      rank: 'D',
      number: 166,
      name: '何日後になるか',
      url: 'https://paiza.jp/challenges/405/ready',
      difficulty: 847,
    )
    expect(problem).to be_valid
  end

  it 'ランクがなければ無効である' do
    problem = Problem.new(rank: nil)
    problem.valid?
    expect(problem.errors[:rank]).to include('を入力してください')
  end

  it '問題番号がなければ無効である' do
    problem = Problem.new(number: nil)
    problem.valid?
    expect(problem.errors[:number]).to include('を入力してください')
  end

  it '問題名がなければ無効である' do
    problem = Problem.new(name: nil)
    problem.valid?
    expect(problem.errors[:name]).to include('を入力してください')
  end

  it 'URLがなければ無効である' do
    problem = Problem.new(url: nil)
    problem.valid?
    expect(problem.errors[:url]).to include('を入力してください')
  end

  it '難易度がなければ無効である' do
    problem = Problem.new(difficulty: nil)
    problem.valid?
    expect(problem.errors[:difficulty]).to include('を入力してください')
  end

  it '同じ名前の問題を複数登録できない' do
    Problem.create(
      rank: 'D',
      number: 166,
      name: '何日後になるか',
      url: 'https://paiza.jp/challenges/405/ready',
      difficulty: 847,
    )
    problem = Problem.new(
      rank: 'D',
      number: 166,
      name: '何日後になるか',
      url: 'https://paiza.jp/challenges/405/ready',
      difficulty: 847,
    )
    problem.valid?
    expect(problem.errors[:name]).to include('はすでに存在します')
  end

  it '同じURLの問題を複数登録できない' do
    Problem.create(
      rank: 'D',
      number: 166,
      name: '何日後になるか',
      url: 'https://paiza.jp/challenges/405/ready',
      difficulty: 847,
    )
    problem = Problem.new(
      rank: 'D',
      number: 166,
      name: '何日後になるか',
      url: 'https://paiza.jp/challenges/405/ready',
      difficulty: 847,
    )
    problem.valid?
    expect(problem.errors[:url]).to include('はすでに存在します')
  end

  # インスタンスメソッドのテスト
  describe 'インスタンスメソッド' do
    it '分:秒の形式に変換する' do
      problem = Problem.new(
        average_time_min: 1,
        average_time_sec: 23,
      )
      expect(problem.average_time).to eq '01:23'
    end
  end

  # クラスメソッドのテスト
  describe 'クラスメソッド' do
    it 'IDからURLを取得する' do
      url = Problem.get_url_from_id(17)
      expect(url).to eq 'https://paiza.jp/challenges/17/ready'
    end

    it 'タイトルからランク、番号、問題名をパースする' do
      title = 'S015:ABC文字列'
      expect(Problem.parse_title(title)).to eq ['S', 15, 'ABC文字列']
    end
  end
end
