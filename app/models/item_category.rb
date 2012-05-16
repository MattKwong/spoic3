# == Schema Information
# Schema version: 20110202025751
#
# Table name: food_item_categories
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  position :integer
#  type_id :integer

#ItemType is the highest level category, i.e. food, tool, material, etc.
#ItemCategory is a lower-level classification linked to the item_type

class ItemCategory < ActiveRecord::Base
  attr_accessible :name, :position, :item_type_id
  belongs_to :item_type
  has_many :items

  validates :name, :item_type_id, :presence => true
  validates :name, :uniqueness => true


#  acts_as_list

  default_scope :order => :position

  before_destroy :reassign_category

  def to_s
    name
  end

  private

  def reassign_category
    other = FoodItemCategory.find_by_name("Other")
    food_items.each do |item|
      item.update_attributes(:food_item_category_id => other.id)
    end
  end
end
