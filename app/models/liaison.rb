class Liaison < ActiveRecord::Base

  scope :scheduled, where(:scheduled => 't')
  scope :unscheduled, where(:scheduled => 'f')

  belongs_to :church
  belongs_to :liaison_type
  has_many :scheduled_groups
  has_many :registrations

  accepts_nested_attributes_for :registrations
  accepts_nested_attributes_for :scheduled_groups

  attr_accessible :active, :address1, :address2, :city, :state, :zip, :first_name,
        :last_name, :name, :email1, :email2, :cell_phone, :home_phone, :work_phone,
        :fax, :liaison_type, :title, :church_id, :liaison_type_id, :id, :registered, :scheduled

  before_validation do
    if self.cell_phone[0..1] == '1-'
      self.cell_phone[0..1] = ''
    end
    if self.home_phone[0..1] == '1-'
      self.home_phone[0..1] = ''
    end
    if self.work_phone[0..1] == '1-'
      self.work_phone[0..1] = ''
    end
    if self.fax[0..1] == '1-'
      self.fax[0..1] = ''
    end

    self.cell_phone = self.cell_phone.gsub(/\D/,'')
    self.home_phone = self.home_phone.gsub(/\D/,'')
    self.work_phone = self.work_phone.gsub(/\D/,'')
    self.fax = self.fax.gsub(/\D/,'')

  end

  before_save :create_name
  before_save :format_phone_numbers

  validates :title, :last_name, :first_name, :address1, :city, :church_id, :email1, :presence => true
  validates :email1, :uniqueness => true
  validates :email2, :uniqueness => true, :allow_blank => true

  validates :state, :presence => true,
                    :length => { :is => 2}
  validates_inclusion_of :state, :in => State::STATE_ABBREVIATIONS, :message => 'Invalid state.'
  validates :zip,   :presence => true,
                    :length => { :is => 5},
                    :numericality => true
  validates_format_of :email1,
            :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,
            :message => 'Email appears to be invalid.'

  validates_format_of :email2,
            :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,
            :message => 'Email appears to be invalid.', :allow_blank => true

  validates_numericality_of :work_phone, :home_phone, :cell_phone, :fax,
                      :message => 'Phone number must be 10 digits plus optional separators.',
                      :allow_blank => true

  validates_length_of :work_phone, :home_phone, :cell_phone, :fax,
                      :is => 10,
                      :message => 'Phone number must be 10 digits plus optional separators.',
                      :allow_blank => true

  validate :require_at_least_one_phone

  private

  def create_name
    self.name = self.first_name + ' ' + self.last_name
  end

  def require_at_least_one_phone
    if self.cell_phone == "" && self.home_phone == "" && self.work_phone == "" then
      errors.add(:cell_phone, 'At least one phone number is required.' )
    end
  end

  def format_phone_numbers
     unless self.cell_phone == ""
       self.cell_phone = self.cell_phone.insert 6, '-'
       self.cell_phone = self.cell_phone.insert 3, '-'
     end
     unless self.home_phone == ""
       self.home_phone = self.home_phone.insert 6, '-'
       self.home_phone = self.home_phone.insert 3, '-'
     end
     unless self.work_phone == ""
       self.work_phone = self.work_phone.insert 6, '-'
       self.work_phone = self.work_phone.insert 3, '-'
     end
     unless self.fax == ""
       self.fax = self.fax.insert 6, '-'
       self.fax = self.fax.insert 3, '-'
     end
  end
end
