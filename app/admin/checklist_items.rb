ActiveAdmin.register ChecklistItem do
  controller.authorize_resource
  menu :if => proc{ can?(:read, ChecklistItem) }, :parent => "Configuration"
  show :title => :name
end
