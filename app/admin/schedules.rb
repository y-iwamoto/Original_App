if ActiveRecord::Base.connection.table_exists? 'schedules'
  ActiveAdmin.register Schedule do
   config.per_page = 10
   actions :index, :show
  # 一覧ページの検索条件
  filter :user_id, label: 'ユーザ', as: :select, collection: User.all.map { |a| [a.username, a.id] }
  filter :from_date
  filter :to_date
  filter :title
  filter :memo
  remove_filter :created_at, :updated_at,:schedule_each_dates
  # 一覧ページ
    index do
      column :id
      column :title
      column :memo
      column :from_date
      column :to_date
      column :user_id do |schedule|
        if schedule.user_id != nil
          User.find(schedule.user_id).username
        end
      end
      actions
    end
    # 詳細ページ
    show do
      attributes_table do
        row :id
        row :title
        row :memo
        row :from_date
        row :to_date
        row :user_id do |schedule|
          if schedule.user_id != nil
            User.find(schedule.user_id).username
          end
        end
      end
    end

  end
end
