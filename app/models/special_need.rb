class SpecialNeed < ActiveRecord::Base
  attr_accessible :name, :list_priority

  validates :name, :presence => true, :uniqueness => true
  validates :list_priority, :presence => true, :uniqueness => true

end
