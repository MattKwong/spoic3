ActiveAdmin.register Project do
  controller.authorize_resource
  menu :if => proc{ can?(:read, Project) }, :parent => "Projects"
  show :title => :name

  index do
    column :name, :sortable => :name do |project|
      link_to project.name, project_path(project)
    end

    column :project_subtype
    column "Untracked Percentage" do |project|
      project.project_subtype.untracked_percentage
    end
    column :program, :sortable => :program_id do |project|
      project.program.name
    end
    column :stage
#TODO: A problem still exists with sorting by estimated_cost and actual_days
    column "Estimated Start", :planned_start
    column :actual_start
    column :actual_end
    column :estimated_cost do |p| number_to_currency p.estimated_cost end
    column :actual_cost, :sortable => :actual_cost do |p| number_to_currency p.actual_cost end
    column :estimated_days
    column :actual_days #, :sortable => :actual_days do |p| p.actual_days end

  end
  csv do
    column :name
    column :beneficiary_name
    column ("Project Subtype") do |p| p.project_subtype.name end
    column "Untracked Percentage" do |project|
      project.project_subtype.untracked_percentage
    end
    column :address1
    column :address2
    column :city
    column :state
    column :zip
    column :description
    column :telephone1
    column :telephone2
    column :notes
    column :estimated_days
    column :planned_start
    column :actual_start
    column :planned_end
    column :actual_end
    column :created_by
    column :estimated_cost
    column :actual_cost
    column :estimated_days
    column :actual_days
  end
end