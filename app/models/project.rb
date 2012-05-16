class Project < ActiveRecord::Base
  attr_accessible :name, :beneficiary_name, :address1, :address2, :city, :state,:zip, :description,
      :telephone1, :telephone2, :notes, :estimated_days, :planned_start,
      :actual_start, :planned_end, :actual_end, :created_by, :updated_by, :project_type_id, :program_id

  belongs_to :project_subtype, :foreign_key =>  :project_type_id
  belongs_to :program
  belongs_to :admin_user, :foreign_key => :created_by
  has_many :material_item_estimateds, :dependent => :destroy
  has_many :material_item_delivereds, :dependent => :destroy
  has_many :labor_items, :dependent => :destroy

  validates :name, :beneficiary_name, :address1, :city, :state,:zip, :description,
        :telephone1, :estimated_days, :planned_start,
        :created_by, :project_type_id, :program_id, :presence => true
  validate :start_date_before_end_date
  validates :state, :presence => true,
                    :length => { :is => 2}
  validates_inclusion_of :state, :in => State::STATE_ABBREVIATIONS, :message => 'Invalid state.'
  validates :zip,   :presence => true,
                    :length => { :is => 5},
                    :numericality => true
  validates_inclusion_of :stage, :in => ['New', 'Ready for review', 'Approved', 'In progress', 'Complete']

  before_validation do
    self.state = self.state.upcase.first(2)
    if self.telephone1[0..1] == '1-'
      self.telephone1[0..1] = ''
    end
    if self.telephone2[0..1] == '1-'
      self.telephone2[0..1] = ''
    end
    self.telephone1 = self.telephone1.gsub(/\D/,'')
    self.telephone2 = self.telephone2.gsub(/\D/,'')
  end

  before_save :format_phone_numbers

  def stage_new?
    stage.blank? || stage == 'New'
  end
  def stage_ready?
    stage == 'Ready for review'
  end
  def stage_approved?
    stage == 'Approved'
  end
  def stage_in_progress?
    stage == 'In progress'
  end

  def format_phone_numbers
     unless self.telephone1 == ""
       self.telephone1 = self.telephone1.insert 6, '-'
       self.telephone1 = self.telephone1.insert 3, '-'
     end
     unless self.telephone2 == ""
       self.telephone2 = self.telephone2.insert 6, '-'
       self.telephone2 = self.telephone2.insert 3, '-'
     end
  end
  def start_date_before_end_date
    unless planned_end.nil?
      unless planned_end >= planned_start
        errors.add(:planned_end, "date must be after the planned start date")
      end
    end
  end

  def start_date_after_first_session
    if planned_start < self.program.first_session_start
      errors.add(:planned_start, " date must be after the start of the first session.")
    end
  end

  def end_date_before_last_session
    unless planned_end.nil?
      if planned_end > self.program.last_session_end
        errors.add(:planned_end, " date must be before the end of the final session.")
      end
    end
  end

  def actual_days
    (labor_items.map &:actual_days).sum
  end

  def estimated_cost(program)
    total = 0
    material_item_estimateds.each  {|i|
    total += i.cost(program)}
    total
end

  def actual_cost(program)
    total = 0
    material_item_delivereds.each  {|i|
      total += i.cost(program)}
    total
  end
end
