ActiveAdmin.register BudgetItem do
  menu :parent => "Budgets"

  index do
    column :site_id, :sortable => :site_id do |site|
      link_to site.site.name, admin_site_path(site)    end
    column :item_id, :sortable => :item_id do |item|
      link_to item.budget_item_type.name, admin_budget_item_type_path(item) end
    column :amount, :sortable => :amount do |amount|
      div :class => "money" do
        number_to_currency amount.amount, :unit => "&dollar;"
      end
    end
      default_actions
  end
end
