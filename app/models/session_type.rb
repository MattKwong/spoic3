class SessionType < ActiveRecord::Base

  attr_accessible :name, :description

  validates :name, :description, :presence => true
  validates :name, :uniqueness => true

end
