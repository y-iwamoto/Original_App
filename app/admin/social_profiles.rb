if ActiveRecord::Base.connection.table_exists? 'social_profile'
  ActiveAdmin.register SocialProfile do
  # See permitted parameters documentation:
  config.per_page = 10
  actions :index, :show #https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
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
  #filter :user_id, label: 'ユーザ', as: :select, collection: -> {User.all.map { |a| [a.username, a.id] }}
  filter :provider
  remove_filter :created_at, :updated_at,:uid
  # 一覧ページ
    index do
      column :id
      column :provider
      column :user_id do |social_profile|
        if social_profile.user_id != nil
          User.find(social_profile.user_id).username
        end
      end
      actions
    end
    show do
      attributes_table do
        row :id
        row :provider
        row :user_id do |social_profile|
          if social_profile.user_id != nil
            User.find(social_profile.user_id).username
          end
        end
      end
    end


  end
end
