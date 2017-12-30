ActiveAdmin.register User do
  config.per_page = 10
  actions :index, :show
# 一覧ページの検索条件
filter :email
filter :username
# 一覧ページ
  index do
    column :id
    column :email
    column :username
    actions
  end
  # 詳細ページ
  show do
    attributes_table do
      row :id
      row :email
      row :username
    end
  end
end
