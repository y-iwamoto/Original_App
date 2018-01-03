if ActiveRecord::Base.connection.table_exists? 'spot'
  ActiveAdmin.register Spot do
    config.per_page = 10
    actions :index, :show
  #一覧ページの検索条件
  filter :user_id, label: 'ユーザ', as: :select, collection: -> {User.all.map { |a| [a.username, a.id] }}
  filter :name
  filter :favorite_flg
  remove_filter :created_at, :updated_at,:latitude,:longitude,:address
  # 一覧ページ
    index do
      column :id
      column :name
      column :address
      column :place_id
      column :user_id do |spot|
        if spot.user_id != nil
          User.find(spot.user_id).username
        end
      end
      column :favorite_flg
      actions
    end
    # 詳細ページ
    show do
      attributes_table do
        row :id
        row :name
        row :address
        row :place_id
        row :user_id do |spot|
          if spot.user_id != nil
            User.find(spot.user_id).username
          end
        end
        row :favorite_flg
      end
    end
  end
end
