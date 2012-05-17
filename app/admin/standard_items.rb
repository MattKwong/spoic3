ActiveAdmin.register StandardItem do
  controller.authorize_resource
  menu :if => proc{ can?(:manage, StandardItem) },:parent => "Projects"

end
