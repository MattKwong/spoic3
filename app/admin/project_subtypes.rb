ActiveAdmin.register ProjectSubtype do
  controller.authorize_resource
  menu :if => proc{ can?(:manage, ProjectSubtype) },:parent => "Projects"
  show :title => :compound_name

  index do
    column :project_type
    column :name
    column :untracked_percentage
    default_actions
  end

  form do |f|
    f.inputs "User Details" do
      f.input :project_type
      f.input :name
      f.input :untracked_percentage, :hint => "This is the expected cost of untracked items as a percentage of the total."
    end
    f.buttons
    end
end
