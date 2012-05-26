ActiveAdmin.register Item do
  controller.authorize_resource
  menu :if => proc{ can?(:read, Item) }, :parent => "Items"
  show :title => :name

form do |f|
  f.inputs "Item Details" do
    f.input :program, :hint => "To be left blank if this item is being input for all sites"
    f.input :item_type, :include_blank => false, :hint => "The highest level classification of an item."
    f.input :item_category, :include_blank => false, :hint => "The classification of the item within this type."
    f.input :budget_item_type, :include_blank => false, :hint => "The budget against which a purchase of this item will be charged."
    f.input :name
    f.input :base_unit, :hint => "Input lbs, oz, ft, gal, etc. Leave blank if the correct base unit is each"
    f.input :description
    f.input :notes
  end
  f.buttons
end
end
