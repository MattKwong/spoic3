ActiveAdmin.register ProgramUser do
  controller.authorize_resource
  menu :if => proc{ can?(:read, Job) }, :parent => "Users and Logs"

end
