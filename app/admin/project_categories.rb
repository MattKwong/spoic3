ActiveAdmin.register ProjectCategory do
  controller.authorize_resource
  menu :if => proc{ can?(:manage, ProjectCategory) },:parent => "Projects"
  show :title => :name
end
