ActiveAdmin.register ProjectType do
  controller.authorize_resource
  menu :if => proc{ can?(:manage, ProjectType) },:parent => "Projects"
  show :title => :name
  
end
