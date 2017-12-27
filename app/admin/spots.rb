ActiveAdmin.register Spot do
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
permit_params :name, :address, :place_id, :favorite_flg
form do |f|
    inputs  do
      input :name
      input :address
      input :name
      input :place_id
      input :favorite_flg
    end

    actions
  end

end
