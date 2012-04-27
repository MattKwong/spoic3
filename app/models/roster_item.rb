class RosterItem < ActiveRecord::Base

  attr_accessible :id, :roster_id, :first_name, :last_name, :address1, :address2, :city, :state, :zip,
    :group_id, :male, :youth, :shirt_size, :email, :grade_in_fall, :disclosure_status, :covenant_status,
      :background_status, :special_need

  scope :youth, (where :youth => 't')
  scope :adults, (where :youth => 'f')

  scope :disclosure_received_all, (where :disclosure_status => 'Received')
  scope :disclosure_received, adults.disclosure_received_all
  scope :disclosure_incomplete_all, (where :disclosure_status => 'Incomplete')
  scope :disclosure_incomplete, adults.disclosure_incomplete_all
  scope :disclosure_not_received_all, (where :disclosure_status => 'Not Received')
  scope :disclosure_not_received, adults.disclosure_not_received_all

  scope :covenant_received_all, (where :covenant_status => 'Received')
  scope :covenant_received, adults.covenant_received_all
  scope :covenant_incomplete_all,  (where :covenant_status => 'Incomplete')
  scope :covenant_incomplete, adults.covenant_incomplete_all
  scope :covenant_not_received_all,  (where :covenant_status => 'Not Received')
  scope :covenant_not_received, adults.covenant_not_received_all

  scope :background_church_verified_all, (where :background_status => 'Church Verified')
  scope :background_church_verified, adults.background_church_verified_all
  scope :background_church_online_ver_all,  (where :background_status => 'Online Verified')
  scope :background_church_online_ver, adults.background_church_online_ver_all
  scope :background_not_received_all,  (where :background_status => 'Not Received')
  scope :background_not_received, adults.background_not_received_all

  belongs_to :roster


  before_validation do
    self.state = self.state.upcase.first(2)
    end

  validates :roster_id, :first_name, :last_name, :address1, :city, :state, :group_id,
    :shirt_size, :email, :presence => true

  validates :state, :presence => true,
                    :length => { :is => 2}
  validates_inclusion_of :state, :in => State::STATE_ABBREVIATIONS, :message => 'Invalid state.'

#  validates_inclusion_of :special_need, :in => SpecialNeed.all.map {|need| need.name}, :message => 'Invalid need type.'
  validates :zip,   :presence => true,
                    :length => { :is => 5},
                    :numericality => true

  with_options :if => :youth? do |registration|
    registration.validates_format_of :email,
            :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,
            :message => 'Email appears to be invalid.', :allow_blank => true
    registration.validates :grade_in_fall, :presence => true
  end
  with_options :if => :adult? do |registration|
    registration.validates_format_of :email,
            :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,
            :message => 'Email appears to be invalid.', :allow_blank => false
    registration.validates_inclusion_of :disclosure_status, :in => ['Received', 'Incomplete', 'Not Received']
    registration.validates_inclusion_of :covenant_status, :in => ['Received', 'Incomplete', 'Not Received']
    registration.validates_inclusion_of :background_status, :in => ['Church Verified', 'Online Verified', 'Not Received']
  end

  def adult?
    !youth || nil
  end

  def group_name
    roster.scheduled_group.name
  end

  def youth_or_counselor
    if youth
      "Youth"
    else
      "Counselor"
    end
  end

  def gender
    if male
      "Male"
    else
      "Female"
    end
  end

end
