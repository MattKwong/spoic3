class Organization < ActiveRecord::Base
  has_many :church_type

  attr_accessible :name

  validates :name, :presence => true, :uniqueness => true

end
