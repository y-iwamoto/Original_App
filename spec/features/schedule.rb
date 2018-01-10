require 'rails_helper'
require 'date'
RSpec.describe "Schedules", :type => :feature do
  let(:user) { FactoryGirl.create(:user) }
  before do
    # ログイン画面でログインさせる
    visit new_user_session_path
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    click_button 'ログイン'
    # スケジュール画面へ遷移
    visit travel_planning_index_path
  end
  describe '初期表示' do
    context '初期表示共通' do
      it 'アラートが出ていないこと' do
        expect(page).to have_no_css '.alert-danger'
      end
      it '新規登録ボタンが表示されていること' do
        expect(page).to have_css '.glyphicon-plus'
      end
    end
    context 'スケジュールが０件の場合' do
       it 'テーブルが表示されていないこと' do
         expect(page).to have_no_css '.table'
       end
    end
    context 'スケジュールが1件以上の場合' do
      let(:schedule) { FactoryGirl.create(:schedule_feature,user_id: user.id) }
      before do
        schedule
        visit travel_planning_index_path
      end
       it 'テーブルが表示されていること' do
        expect(page).to have_css '.table'
       end
       it '対象データのタイトルが表示されていること' do
         expect(page).to have_selector 'table tr td', text: schedule.title
       end
       it '対象データの開始日付と終了日付が表示されていること' do
         expect(page).to have_selector 'table tr td', text: "#{schedule.from_date }〜#{schedule.to_date }"
       end
       it '更新ボタンが表示されていること' do
         expect(page).to have_css '.glyphicon-pencil'
       end
       it '削除ボタンが表示されていること' do
         expect(page).to have_css '.glyphicon-trash'
       end
       it 'スケジュール日付画面遷移ボタンが表示されていること' do
         expect(page).to have_css '.glyphicon-calendar'
       end
     end
     context 'スケジュールが11件以上の場合(ページングあり)' do
      before(:each) do
        #スケジュールデータをタイトル名がtest1~test11で作成
        i = 1
        11.times do
           FactoryGirl.create(:schedule_feature,user_id: user.id,title: "test_" + i.to_s )
           i = i + 1
        end
        visit travel_planning_index_path
      end
       it '１ページ目のタイトルでtest1が表示されていること' do
         expect(page).to have_selector 'table tr td', text: 'test_1'
       end
      it 'ページングが表示されていること' do
        expect(page).to have_css '.pagination'
      end
      it 'ページングが番号が１で表示されていること' do
        expect(all('ul.pagination li.active a')[0]).to have_content "1"
      end
      it '２ページ目に遷移した際に、ページングが番号が2で表示されていること' do
        all('ul.pagination li')[1].find("a").click
        expect(all('ul.pagination li.active a')[0]).to have_content "2"
      end
      it '２ページ目に遷移した際に、タイトルでtest11が表示されていること' do
        all('ul.pagination li')[1].find("a").click
        expect(page).to have_selector 'table tr td', text: 'test_11'
      end
     end
  end
  describe '登録時' do
    let(:schedule) { FactoryGirl.create(:schedule_feature,user_id: user.id) }
    let(:handle) { page.driver.browser.window_handles.last}
    context 'モーダル表示' do
      before do
        schedule
        visit travel_planning_index_path
        find('.glyphicon-plus').click
      end
      it 'モーダルのタイトルが登録で表示されていること' , js: true do
        page.driver.browser.within_window(handle) do
          expect(page).to have_content 'スケジュールの登録'
        end
      end
      it 'タイトルが空で表示されていること' , js: true do
        page.driver.browser.within_window(handle) do
          expect(find('#schedule_title').value).to eq ''
        end
      end
      it '開始日付が今日の日付で表示されていること' , js: true do
        page.driver.browser.within_window(handle) do
          expect(find('#schedule_from_date').value).to eq Date.today.strftime("%Y-%m-%d")
        end
      end
      it '終了日付が今日の日付で表示されていること'  , js: true do
        page.driver.browser.within_window(handle) do
          expect(find('#schedule_to_date').value).to eq Date.today.strftime("%Y-%m-%d")
        end
      end
    end
    context '登録正常系' do
      before(:each, :js => true) do
        schedule
        visit travel_planning_index_path
        find('.glyphicon-plus').click
        page.driver.browser.within_window(handle) do
          fill_in 'schedule_title', with: 'test1'
          fill_in 'schedule_from_date', with: '2017-12-12'
          fill_in 'schedule_to_date', with: '2018-01-12'
          click_button '登録'
        end
      end
      it '登録メッセージが表示されること'  , js: true do
          expect(page).to have_content 'スケジュールを作成しました'
      end

      it '入力したタイトルが表示されること'  , js: true do
          expect(page).to have_selector 'table tr td', text: 'test1'
      end
      it '入力した開始日付が表示されること'  , js: true do
          expect(page).to have_selector 'table tr td', text: '2017-12-12'
      end
      it '入力した終了日付が表示されること'  , js: true do
          expect(page).to have_selector 'table tr td', text: '2018-01-12'
      end
    end
    context '登録異常系(入力が空)' do
      before(:each, :js => true) do
        schedule
        visit travel_planning_index_path
        find('.glyphicon-plus').click
        page.driver.browser.within_window(handle) do
          fill_in 'schedule_title', with: ''
          fill_in 'schedule_from_date', with: ''
          fill_in 'schedule_to_date', with: ''
          click_button '登録'
        end
      end
      it '入力したタイトルが表示されないこと'  , js: true do
          expect(page).to have_no_selector 'table tr td', text: 'test1'
      end
      it '入力した開始日付が表示されないこと'  , js: true do
          expect(page).to have_no_selector 'table tr td', text: '2017-12-12'
      end
      it '入力した終了日付が表示されないこと'  , js: true do
          expect(page).to have_no_selector 'table tr td', text: '2018-01-12'
      end
    end
    context '登録異常系(入力あり)' do
      before(:each, :js => true) do
        i = 1
        11.times do
           FactoryGirl.create(:schedule_feature,user_id: user.id,title: "test_" + i.to_s )
           i = i + 1
        end
        visit travel_planning_index_path
        find('.glyphicon-plus').click
        page.driver.browser.within_window(handle) do
          fill_in 'schedule_title', with: 'tess21'
          fill_in 'schedule_from_date', with: '2018-01-01'
          fill_in 'schedule_to_date', with: '2017-12-21'
          click_button '登録'
        end
      end
      it '入力したタイトルが表示されないこと'  , js: true do
          expect(page).to have_no_selector 'table tr td', text: 'test21'
      end
      it 'エラーメッセージが表示されていること'  , js: true do
          expect(page).to have_css '.alert-danger'
      end
      it 'エラーを起こしても新規登録ボタンが表示されていること' , js: true do
        expect(page).to have_css '.glyphicon-plus'
      end
      it 'エラーを起こしてもページングボタンが表示されていること' , js: true do
        expect(page).to have_css '.pagination'
      end

    end
  end
  describe '更新時' do
    let(:schedule) { FactoryGirl.create(:schedule_feature,user_id: user.id) }
    let(:handle) { page.driver.browser.window_handles.last}
    context 'モーダル表示' do
      before do
        schedule
        visit travel_planning_index_path
        click_link nil, href: edit_travel_planning_path(schedule)
      end
      it 'モーダルのタイトルが更新で表示されていること' , js: true do
        page.driver.browser.within_window(handle) do
          expect(page).to have_content 'スケジュールの更新'
        end
      end
      it 'タイトルが登録値で表示されていること' , js: true do
        page.driver.browser.within_window(handle) do
          expect(find('#schedule_title').value).to eq schedule.title
        end
      end
      it '開始日付が登録値で表示されていること' , js: true do
        page.driver.browser.within_window(handle) do
          expect(find('#schedule_from_date').value).to eq schedule.from_date.strftime("%Y-%m-%d")
        end
      end
      it '終了日付が登録値で表示されていること'  , js: true do
        page.driver.browser.within_window(handle) do
          expect(find('#schedule_to_date').value).to eq schedule.to_date.strftime("%Y-%m-%d")
        end
      end
      context '更新正常系' do
        before(:each, :js => true) do
          schedule
          visit travel_planning_index_path
          click_link nil, href: edit_travel_planning_path(schedule)
          page.driver.browser.within_window(handle) do
            fill_in 'schedule_title', with: 'test1'
            fill_in 'schedule_from_date', with: '2017-12-12'
            fill_in 'schedule_to_date', with: '2018-01-12'
            click_button '更新'
          end
        end
        it '更新メッセージが表示されること'  , js: true do
            expect(page).to have_content 'スケジュールを更新しました'
        end
        it '入力したタイトルが表示されること'  , js: true do
            expect(page).to have_selector 'table tr td', text: 'test1'
        end
        it '入力した開始日付が表示されること'  , js: true do
            expect(page).to have_selector 'table tr td', text: '2017-12-12'
        end
        it '入力した終了日付が表示されること'  , js: true do
            expect(page).to have_selector 'table tr td', text: '2018-01-12'
        end
      end
      context '更新異常系(入力あり)' do
        before(:each, :js => true) do
          schedule
          visit travel_planning_index_path
          click_link nil, href: edit_travel_planning_path(schedule)
          page.driver.browser.within_window(handle) do
            fill_in 'schedule_title', with: 'tess21'
            fill_in 'schedule_from_date', with: '2018-01-01'
            fill_in 'schedule_to_date', with: '2017-12-21'
            click_button '更新'
          end
        end
        it '入力したタイトルが表示されないこと'  , js: true do
            expect(page).to have_no_selector 'table tr td', text: 'test21'
        end
        it 'エラーメッセージが表示されていること'  , js: true do
            expect(page).to have_css '.alert-danger'
        end
        it 'タイトルが更新前の状態で表示されていること' , js: true do
          expect(page).to have_selector 'table tr td', text: schedule.title
        end
      end
    end
  end
  describe '削除時' do
    let(:schedule) { FactoryGirl.create(:schedule_feature,user_id: user.id) }
    let(:handle) { page.driver.browser.window_handles.last}
    before do
      schedule
      visit travel_planning_index_path
      click_link nil, href: travel_planning_path(schedule)
    end
    it 'ダイアログが表示されること' , js: true do
        expect(page.accept_confirm).to eq '削除してよろしいでしょうか?'
    end
    it '対象データが削除されること'  do
        expect(page).to have_no_selector 'table tr td', text: schedule.title
    end
    it '削除メッセージが表示されること' do
        expect(page).to have_content 'スケジュールを削除しました'
    end
  end
  describe 'スケジュール日付別遷移確認' do
    let(:schedule) { FactoryGirl.create(:schedule_feature,user_id: user.id) }
    before do
      schedule
      visit travel_planning_index_path
      click_link nil, href: travel_planning_date_index_path(:schedule_id => schedule.id)
    end
    it 'スケジュール日付別画面に遷移していること' do
        expect(current_url).to include 'travel_planning_date?schedule_id=1'
    end
  end
end
