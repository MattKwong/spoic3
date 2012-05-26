ActiveAdmin.register StandardItem do
  controller.authorize_resource
  menu :if => proc{ can?(:manage, StandardItem) },:parent => "Projects"

  form do |f|
    f.inputs "Project Type Details" do
      f.input :project_subtype, :include_blank => false
      f.input :item, :include_blank => false, :as => :select, :collection => Item.materials.alphabetized
      f.input :comments
    end
    f.buttons
    end


end
