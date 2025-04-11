ActiveAdmin.register Plan do
  permit_params :name, :amount, :interval, :trial_period_days, :currency, :description,
                :unit_label, :charge_per_unit, :contact_url, :formatted_features, :private

  index do
    selectable_column
    id_column
    column :name
    column :amount
    column :interval
    column :currency
    column :private
    actions
  end

  filter :name
  filter :amount
  filter :interval
  filter :currency
  filter :private

  form do |f|
    f.inputs do
      f.input :name
      f.input :private
      f.input :amount, label: 'Amount (in cents)'
      f.input :interval
      f.input :trial_period_days
      f.input :currency
      f.input :description, as: :text
      f.input :unit_label
      f.input :charge_per_unit
      f.input :contact_url

      f.input :formatted_features, as: :text, label: 'Features'
    end

    f.actions
  end
end
