ActiveAdmin.register Program do
  controller.authorize_resource
  menu :if => proc{ can?(:read, Program) }, :parent => "Configuration"
  show :title => :name

end
