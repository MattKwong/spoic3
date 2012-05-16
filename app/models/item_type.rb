#ItemType is the highest level category, i.e. food, tool, material, etc.
#ItemCategory is a lower-level classification linked to the item_type
class ItemType < ActiveRecord::Base

  attr_accessible :name
  has_many :items
  has_many :item_category
  validates :name, :item_category_id, :presence => true
  validates :name, :uniqueness => true

end
