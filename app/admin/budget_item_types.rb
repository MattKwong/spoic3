ActiveAdmin.register BudgetItemType do
  controller.authorize_resource
  menu :if => proc{ can?(:read, BudgetItemType) }, :parent => "Budgets"
  show :title => :name
end
