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

    index do
        column :item do |item|
          link_to item.item.name, item_path(item)
        end
        column "Comments", :comments
        column :project_subtype do |item|
           item.project_subtype.name
        end
        column :project_type do |item|
           item.project_subtype.project_type.name
        end

        #column("Comments") {   standard_item.title }
        #column("  standard_item to") {   standard_item.church do |church|
        #  link_to   standard_item.church, [:admin, church]
        #end }
        #column("  standard_item Type") {   standard_item.  standard_item_type}
        #column("Address") {   standard_item.address1 }
        #column("Address 2") {  standard_item.address2 }
        #column("City") {  standard_item.city}
        #column("State") {  standard_item.state }
        #column("Zip code") {  standard_item.zip }
        #column("Last update") {   standard_item.updated_at }
        #column("Has registered group?") {   standard_item.registered }
        #column("Has scheduled group?") {   standard_item.scheduled }
      end


end
