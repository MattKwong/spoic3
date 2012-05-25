ActiveAdmin.register BudgetItem do

  controller.authorize_resource
  menu :if => proc{ can?(:read, BudgetItem) }, :parent => "Budgets"

  index do
    column :program_id, :sortable => :program_id do |program|
      link_to program.program.name, admin_program_path(program)
    end
    column :item_id, :sortable => :item_id do |item|
      link_to item.budget_item_type.name, admin_budget_item_type_path(item) end
    column :amount do |amount|
      div :class => "money" do
        number_to_currency amount.amount, :unit => "&dollar;"
      end
    end
      default_actions
  end
  form do |f|
     f.inputs "New Budget Item" do
       f.input :budget_item_type, :include_blank => false
       f.input :program, :include_blank => false
       f.input :amount, :hint => "Enter the amount, including decimal point if needed, without a dollar sign."
     end
     f.buttons
   end
end
