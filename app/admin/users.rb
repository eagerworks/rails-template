ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation, :full_name, :admin

  action_item :impersonate, only: :show do
    link_to 'Impersonate', impersonate_admin_user_path(resource), method: :post,
                                                                  class: 'action-item-button'
  end

  member_action :impersonate, method: :post do
    user = User.find(params[:id])
    impersonate_user(user)
    redirect_to root_path
  end

  index do
    selectable_column
    id_column
    column :full_name
    column :email
    column :admin
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  filter :full_name
  filter :email
  filter :admin
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs do
      f.input :full_name
      f.input :email
      f.input :admin
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end
end
