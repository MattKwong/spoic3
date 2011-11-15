class LiaisonType < ActiveRecord::Base

  attr_accessible :name, :description

  validates :name, :presence => true, :uniqueness => true
  validates :description, :presence => true

end
