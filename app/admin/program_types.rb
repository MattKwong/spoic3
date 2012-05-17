ActiveAdmin.register ProgramType do
  controller.authorize_resource
  menu :if => proc{ can?(:read, ProgramType) }, :parent => "Configuration"
  show :title => :name
end
