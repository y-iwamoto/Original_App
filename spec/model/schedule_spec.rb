require'rails_helper'

describe Schedule do
  let(:schedule) { FactoryGirl.build(:schedule,params) }
  describe 'title' do
    let(:params) { { title: title} }
    context '入力されていた場合' do
      let(:title) { 'title' }
      it '入力確認' do
        expect(schedule.title).to eq 'title'
      end
    end
    context '未入力の場合' do
      let(:title) { '' }
      it 'エラー' do
        expect(schedule).not_to be_valid
      end
    end
    context '100文字入力されていた場合' do
      let(:title) { '0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789' }
      it '入力確認' do
        expect(schedule.title).to eq '0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789'
      end
    end
    context '101文字入力されていた場合' do
      let(:title) { '01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890' }
      it 'エラー' do
        expect(schedule).not_to be_valid
      end
    end
  end
  describe 'from_date' do
    let(:params) { { from_date: from_date} }
    context '入力されていた場合' do
      let(:from_date) { '2017-10-10' }
      it '入力確認' do
        expect(schedule.from_date).to eq Date.parse('2017-10-10')
      end
    end
    context '未入力の場合' do
      let(:from_date) { '' }
      it 'エラー' do
        expect(schedule).not_to be_valid
      end
    end
    context '日付以外の形式の場合' do
      let(:from_date) { 'aaa' }
      it 'エラー' do
        expect(schedule).not_to be_valid
      end
    end
  end
  describe 'to_date' do
    let(:params) { { to_date: to_date} }
    context '入力されていた場合' do
      let(:to_date) { '2017-10-10' }
      it '入力確認' do
        expect(schedule.to_date).to eq Date.parse('2017-10-10')
      end
    end
    context '未入力の場合' do
      let(:to_date) { '' }
      it 'エラー' do
        expect(schedule).not_to be_valid
      end
    end
    context '日付以外の形式の場合' do
      let(:to_date) { 'aaa' }
      it 'エラー' do
        expect(schedule).not_to be_valid
      end
    end
  end
  describe 'from_dateとto_dateの大小関係' do
    let(:params) { { from_date: from_date,to_date: '2017-12-10'} }
    context 'from_date > to_date' do
      let(:from_date) { '2017-12-12' }
      it 'エラー' do
        expect(schedule).not_to be_valid
      end
    end
    context 'from_date = to_date' do
      let(:from_date) { '2017-12-10' }
      it '正常' do
        expect(schedule).to be_valid
      end
    end
    context 'from_date < to_date' do
      let(:from_date) { '2017-12-08' }
      it '正常' do
        expect(schedule).to be_valid
      end
    end
  end
end
