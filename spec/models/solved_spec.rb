require 'rails_helper'

RSpec.describe Solved, type: :model do
  it '有効なファクトリを持つ' do
    # createすると、自動的に関連先のモデルのインスタンスが作られる
    # buildした場合は作られない(nilのまま)
    solved = FactoryBot.create(:solved)
    expect(solved).to be_valid
  end

  # バリデーションのテスト
  describe 'バリデーション' do
    before do
      @user = FactoryBot.create(:user)
      @other_user = FactoryBot.create(:other_user)
      @problem = FactoryBot.create(:problem)
      @other_problem = FactoryBot.create(:other_problem)
    end

    context 'user_idカラム' do
      it '存在しなければ無効である' do
        solved = FactoryBot.build(:solved, user: nil, problem: @problem)
        solved.valid?
        expect(solved.errors[:user]).to include('を入力してください')
        expect(solved.errors[:user_id]).to include('を入力してください')
      end
    end

    context 'problem_idカラム' do
      it '存在しなければ無効である' do
        solved = FactoryBot.build(:solved, user: @user, problem: nil)
        solved.valid?
        expect(solved.errors[:problem]).to include('を入力してください')
        expect(solved.errors[:problem_id]).to include('を入力してください')
      end
    end

    context 'first_socreカラム' do
      it '存在しなければ無効である' do
        solved = FactoryBot.build(:solved, user: @user, problem: @problem, first_score: nil)
        solved.valid?
        expect(solved.errors[:first_score]).to include('を入力してください')
      end
    end

    it '同じユーザーは同じ問題を２回解くことが出来ない' do
      FactoryBot.create(:solved, user: @user, problem: @problem)
      solved = FactoryBot.build(:solved, user: @user, problem: @problem)
      solved.valid?
      expect(solved).to_not be_valid
      expect(solved.errors[:user_id]).to include('はすでに存在します')
    end

    it '同じユーザーは別の問題を解くことが出来る' do
      FactoryBot.create(:solved, user: @user, problem: @problem)
      solved = FactoryBot.create(:solved, user: @user, problem: @other_problem)
      expect(solved).to be_valid
    end

    it '別のユーザーは同じ問題を解くことが出来る' do
      FactoryBot.create(:solved, user: @user, problem: @problem)
      solved = FactoryBot.create(:solved, user: @other_user, problem: @problem)
      expect(solved).to be_valid
    end
  end
end
