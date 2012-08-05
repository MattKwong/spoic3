ActiveAdmin.register Purchase do
  controller.authorize_resource
  menu :if => proc{ can?(:read, Purchase) }, :priority => 6
  show :title => "#{:vendor} #{:date}"
  #scope :incomplete

  #filter :unaccounted_for, :as => :float
  #filter :program
  #filter :vendor
  #filter :unaccounted, :as => :select

  index do
    column "Purchase", :sortable => :vendor_id do |purchase|
      link_to "#{purchase.vendor} #{purchase.date}", purchase_path(purchase.id)
    end

    column :program, :sortable => :program_id do |purchase|
      purchase.program.name
    end

    column :vendor, :sortable => :vendor_id do |purchase|
      link_to purchase.vendor, vendor_path(purchase.vendor_id)
    end
    column :date

    column :purchaser, :sortable => :purchaser_id
    column :purchase_type
    column :total, :sortable => :total do |purchase| number_to_currency purchase.total end
    column :tax do |purchase| number_to_currency purchase.tax end
    column :unaccounted_for, :sortable => false do |purchase| number_to_currency purchase.unaccounted_for end


    column "Budget Type" do |purchase|
      if purchase.budget_type == "Split"
        link_to "Split Receipt", purchase_budget_path(purchase.id)
      else
        purchase.budget_type
      end
    end
  end

  csv do
    column ("Purchase Name") do |p| p.to_s end
    column :program
    column :vendor
    column :date
    column :purchaser
    column :purchase_type
    column :total
    column :tax
    column :unaccounted_for do |p| '%.2f' % p.unaccounted_for end
    column :budget_type
  end
end