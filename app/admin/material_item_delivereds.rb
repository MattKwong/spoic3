ActiveAdmin.register MaterialItemDelivered do
  controller.authorize_resource
  menu :if => proc{ can?(:read, MaterialItemDelivered) }, :parent => "Projects"
  show :title => "All delivered items - all active programs"

  index do
    column :item, :sortable => :item_id do |delivered_item|
      delivered_item.item.name
    end
    column :program do |delivered_item|
      delivered_item.project.program.name
    end
    column :project do |delivered_item|
      delivered_item.project.name
    end
    column :project_subtype do |delivered_item|
      delivered_item.project.project_subtype.name
    end
    column :delivery_date
    column :cost do |delivered_item|
      delivered_item.item.average_cost(delivered_item.project.program, Date.today)
    end
    column :default_cost do |delivered_item|
      delivered_item.item.default_cost
    end
  end

  csv do
    column ("Item Name") do |delivered_item|
      delivered_item.item.name
    end
    column ("Program") do |delivered_item|
      delivered_item.project.program.name
    end
    column ("Project Name") do |delivered_item|
      delivered_item.project.name
    end
    column ("Project Subtype") do |delivered_item|
      delivered_item.project.project_subtype.name
    end
    column ("Delivery Date") do |delivered_item|
      delivered_item.delivery_date.to_date
    end
    column ("Calculated Ave Cost") do |delivered_item|
      delivered_item.item.average_cost(delivered_item.project.program, Date.today)
    end
    column ("Default Cost") do |delivered_item|
      delivered_item.item.default_cost
    end
  end
end