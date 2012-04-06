# == Schema Information
# Schema version: 20110213051823
#
# Table name: food_inventories
#
#  id         :integer         not null, primary key
#  program_id :integer
#  date       :date
#  created_at :datetime
#  updated_at :datetime
#

class FoodInventory < ActiveRecord::Base
  attr_accessible :date, :food_inventory_food_items_attributes

  belongs_to :program
  has_many :food_inventory_food_items, :dependent => :destroy
  has_many :items, :through => :food_inventory_food_items

  accepts_nested_attributes_for :food_inventory_food_items, :reject_if => proc { |attr| attr[:quantity].blank? }
  
  validates :program_id, :presence => true
  validates :date, :presence => true
  validates_uniqueness_of :date, :scope => :program_id, :message => "An inventory already exists on that date"

  scope :after, lambda { |date| where('date >= ?', date) }
  scope :before, lambda { |date| where('date < ?', date) }

  def total_spent
    (food_inventory_food_items.map &:total_price).sum
  end

  def daily_cost
    total_spent / days_covered
  end

  def days_covered
    previous = program.food_inventories.before(date).order('date DESC').first
    if previous
      date - previous.date
    else
      date - program.weeks.order('start_date ASC').first.start_date + 1
    end
  end

  def value_consumed
    (food_inventory_food_items.map &:total_consumed_cost).sum
  end

  def value_in_inventory
    (food_inventory_food_items.map &:total_inventoried_cost).sum
  end

  def value_previously_in_inventory
    (food_inventory_food_items.map &:total_starting_inventory_cost).sum
  end
end
