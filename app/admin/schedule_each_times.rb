ActiveAdmin.register ScheduleEachTime do
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
filter :place_id, as: :select, collection: Spot.all.map { |a| [a.name, a.id] }
filter :memo
remove_filter :created_at, :updated_at,:schedule_each_date_id
# 一覧ページ
  index do
    column :id
    column :from_time do |schedule_each_time|
      schedule_each_time.from_time.strftime('%H:%M')
    end
    column :to_time do |schedule_each_time|
      schedule_each_time.to_time.strftime('%H:%M')
    end
    column :memo
    column :schedule_id do |schedule_each_time|
      if schedule_each_time.schedule_id != nil
        Schedule.find(schedule_each_time.schedule_id).title
      end
    end
    column :schedule_each_date_id do |schedule_each_time|
      if schedule_each_time.schedule_each_date_id != nil
        ScheduleEachDate.find(schedule_each_time.schedule_each_date_id).sche_date.strftime('%Y/%m/%d')
      end
    end
    column :user_id do |schedule_each_time|
      if schedule_each_time.user_id != nil
        User.find(schedule_each_time.user_id).username
      end
    end
    column :place_id do |schedule_each_time|
      if schedule_each_time.place_id != nil
        Spot.find(schedule_each_time.place_id).name
      end
    end
    actions
  end
  show do
    attributes_table do
      row :id
      row :from_time do |schedule_each_time|
        schedule_each_time.from_time.strftime('%H:%M')
      end
      row :to_time do |schedule_each_time|
        schedule_each_time.to_time.strftime('%H:%M')
      end
      row :memo
      row :schedule_id do |schedule_each_time|
        if schedule_each_time.schedule_id != nil
          Schedule.find(schedule_each_time.schedule_id).title
        end
      end
      row :schedule_each_date_id do |schedule_each_time|
        if schedule_each_time.schedule_each_date_id != nil
          ScheduleEachDate.find(schedule_each_time.schedule_each_date_id).sche_date.strftime('%Y/%m/%d')
        end
      end
      row :user_id do |schedule_each_time|
        if schedule_each_time.user_id != nil
          User.find(schedule_each_time.user_id).username
        end
      end
      row :place_id do |schedule_each_time|
        if schedule_each_time.place_id != nil
          Spot.find(schedule_each_time.place_id).name
        end
      end
    end
  end


end
