ActiveAdmin.register ProjectSubtype do
  controller.authorize_resource
  menu :if => proc{ can?(:manage, ProjectSubtype) },:parent => "Projects"
  show :title => :compound_name
end
