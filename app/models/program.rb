class Program < ActiveRecord::Base
  attr_accessible :site_id, :start_date, :end_date, :program_type_id, :active, :name, :short_name

  belongs_to :site
  belongs_to :program_type

  has_many :program_users
  has_many :admin_users, :through => :program_users
  has_many :sessions
  has_many :scheduled_groups, :through => :sessions
  has_many :budget_items
  has_many :purchases
  has_many :item_purchases, :through => :purchases
  has_many :items
  has_many :food_inventories
  has_many :projects

  validates :name, :presence => true, :uniqueness => true
  validates :short_name, :presence => true, :uniqueness => true
  validates :site_id, :presence => true
  validates :start_date, :presence => true
  validates :end_date, :presence => true
  validates :program_type_id, :presence => true
  validates :active, :inclusion => [true, false]

  validate :start_date_before_end_date
  validate :start_date_not_in_past
  scope :active, where(:active => true)

  def total_days
    total = 0
    sessions.each do |session|
      session.scheduled_groups.each do|group|
        if session.session_type_junior_high?
          total += 3.5 * group.current_total
        else
          total += 4.5 * group.current_total
        end
      end
    end
    total
  end

  def start_date_before_end_date
    unless start_date.nil? or end_date.nil?
      unless start_date < end_date
        errors.add(:end_date, "End date must be after the start date")
      end
    end
  end

  def start_date_not_in_past
     unless start_date.nil?
       if start_date < Date.today - 90
        errors.add(:start_date, "Start date cannot be more than 90 days in the past")
       end
    end
  end

  scope :current, where(:active => true)
  scope :past, where(:active => false)
#  default_scope :include => :site, :order => 'end_date DESC, sites.name ASC'
  before_validation :set_name

  def to_current
    self.sessions.joins(:period).where("start_date < ?", Date.today)
  end

  def first_session_start
    Session.find(first_session_id).period.start_date.to_date
  end

  def last_session_end
    Session.find(last_session_id).period.end_date.to_date
  end

  def to_s
    name
  end

  def adults
    (self.scheduled_groups.map &:current_counselors).sum
  end

  def youth
    (self.scheduled_groups.map &:current_youth).sum
  end

  def total
    adults + youth
  end

  def budget_item_name(budget_item_type_id)
    BudgetItemType.find(budget_item_type_id).name
  end

  def budget_item_spent(budget_item_type_id)
    (self.item_purchases.by_budget_line_type(budget_item_type_id).map &:total_price).sum
  end

  def budget_item_spent_with_tax(budget_item_type_id)
    (self.item_purchases.by_budget_line_type(budget_item_type_id).map &:total_price_with_tax).sum
  end

  def budget_item_budgeted(budget_item_type_id)
    if self.budget_items.find_by_budget_item_type_id(budget_item_type_id)
      self.budget_items.find_by_budget_item_type_id(budget_item_type_id).amount
    else
      0
    end
  end

  def budget_item_remaining(budget_item_type_id)
    budget_item_budgeted(budget_item_type_id) - budget_item_spent_with_tax(budget_item_type_id)
  end

  def budget_item_spent_total
    (self.item_purchases.map &:total_price).sum
  end

  def budget_item_spent_with_tax_total
    (self.item_purchases.map &:total_price_with_tax).sum
  end

  def budget_item_budgeted_total
    (self.budget_items.map &:amount).sum
  end

  def budget_item_remaining_total
    budget_item_budgeted_total - budget_item_spent_with_tax_total
  end

  def purchased_items
    (item_purchases.collect &:item).uniq
  end

  def purchased_food_items
    id = BudgetLineType.find_by_name('Food').id
    (item_purchases.by_budget_line_type(id).collect &:item).uniq
  end

  def purchased_food_items
    food_id = BudgetItemType.find_by_name('Food').id
    (item_purchases.by_budget_line_type(food_id).collect &:item).uniq
  end

  def first_session_id
    s = self.sessions.sort {|a,b| a.period.start_date <=> b.period.start_date }
    #logger.debug s.inspect
    s.first.id
  end
  def last_session_id
    s = self.sessions.sort {|a,b| a.period.start_date <=> b.period.start_date }
    s.last.id
  end

private

  def smart_name
    elements = []
    elements << self.site.name
    elements << self.program_type.name
    elements << self.start_date.year
    less = Program.current.where('site_id = ? AND program_type_id = ? AND programs.id <= ?', site_id, program_type_id, id)
    elements << less.count if less.count > 1
    elements.join(" ")
  end

  def smart_short_name
    elements = []
    elements << self.site.abbr
    elements << self.program_type.abbr_name
    elements << self.start_date.year % 100
    less = Program.current.where('site_id = ? AND program_type_id = ? AND programs.id <= ?', site_id, program_type_id, id)
    elements << less.count if less.count > 1
    elements.join(" ")
  end

  def set_name
    self.name = smart_name
    self.short_name = smart_short_name
  end

end
