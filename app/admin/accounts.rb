ActiveAdmin.register Account do
  permit_params :name, :owner_id, :avatar

  index do
    selectable_column
    id_column
    column :name
    column :owner
    actions
  end

  filter :name
  filter :owner
  filter :created_at

  form do |f|
    f.inputs do
      f.input :name
      f.input :owner
    end
    f.actions
  end

  show do
    attributes_table do
      row :name
      row :owner
      row :personal
      row :created_at
      row :updated_at
    end

    panel 'Account Users' do
      table_for account.account_users do
        column :user
        column :role
        column :created_at
      end
    end

    panel 'Account Invitations' do
      table_for account.account_invitations do
        column :name
        column :email
        column :role
        column :created_at
      end
    end

    active_admin_comments_for(resource)
  end
end
