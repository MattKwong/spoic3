class Site < ActiveRecord::Base
  attr_accessible :id, :address1, :address2, :city, :name, :phone, :state,
                  :zip, :listing_priority, :active
end
