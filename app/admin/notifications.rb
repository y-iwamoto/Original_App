ActiveAdmin.register Notification do
config.per_page = 10
actions :index, :show
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
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
filter :user_id, label: '送信元ユーザ', as: :select, collection: User.all.map { |a| [a.username, a.id] }
filter :opponent_user_id, label: '送信先ユーザ', as: :select, collection: User.all.map { |a| [a.username, a.id] }
filter :content
filter :read_flg
filter :introduce_flg
remove_filter :created_at, :updated_at
# 一覧ページ
  index do
    column :id
    column :content
    column :read_flg
    column :introduce_flg
    column :user_id do |notification|
      if notification.opponent_user_id != nil
        User.find(notification.opponent_user_id).username
      end
    end
    column :opponent_user_id do |notification|
      if notification.user_id != nil
        User.find(notification.user_id).username
      end
    end
    actions
  end
  show do
    attributes_table do
      row :id
      row :content
      row :read_flg
      row :introduce_flg
      row :user_id do |notification|
        if notification.opponent_user_id != nil
          User.find(notification.opponent_user_id).username
        end
      end
      row :opponent_user_id do |notification|
        if notification.user_id != nil
          User.find(notification.user_id).username
        end
      end
    end
  end

end
