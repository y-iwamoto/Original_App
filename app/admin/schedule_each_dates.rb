ActiveAdmin.register ScheduleEachDate do
# See permitted parameters documentation:
config.per_page = 10
actions :index, :show
#https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end
# 一覧ページの検索条件
filter :user_id, label: 'ユーザ', as: :select, collection: User.all.map { |a| [a.username, a.id] }
filter :schedule_id, label: '対象スケジュール', as: :select, collection: Schedule.all.map { |a| [a.title, a.id] }
filter :sche_date
remove_filter :created_at, :updated_at,:schedule_each_times
# 一覧ページ
  index do
    column :id
    column :sche_date do |schedule_each_date|
      if schedule_each_date.sche_date != nil
        schedule_each_date.sche_date.strftime('%Y/%m/%d')
      end
    end
    column :schedule_id do |schedule_each_date|
      if schedule_each_date.schedule_id != nil
        Schedule.find(schedule_each_date.schedule_id).title
      end
    end
    column :user_id do |schedule_each_date|
      if schedule_each_date.user_id != nil
        User.find(schedule_each_date.user_id).username
      end
    end
    actions
  end
  show do
    attributes_table do
      row :id
      row :sche_date do |schedule_each_date|
        if schedule_each_date.sche_date != nil
          schedule_each_date.sche_date.strftime('%Y/%m/%d')
        end
      end
      row :schedule_id do |schedule_each_date|
        if schedule_each_date.schedule_id != nil
          Schedule.find(schedule_each_date.schedule_id).title
        end
      end
      row :user_id do |schedule_each_date|
        if schedule_each_date.user_id != nil
          User.find(schedule_each_date.user_id).username
        end
      end
    end
  end
end
