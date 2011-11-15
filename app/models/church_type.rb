class ChurchType < ActiveRecord::Base
  belongs_to :conference
  belongs_to :denomination
  belongs_to :organization

  attr_accessible :name

  validates :name, :presence => true, :uniqueness => true
end
