ActiveAdmin.register ProjectType do
  controller.authorize_resource
  menu :if => proc{ can?(:manage, ProjectType) },:parent => "Projects"
  show :title => :name

  form do |f|
    f.inputs "Project Type Details" do
      f.input :project_category, :include_blank => false
      f.input :name
      f.input :description
    end
    f.buttons
    end
  
end
