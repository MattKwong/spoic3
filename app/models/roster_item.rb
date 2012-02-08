class RosterItem < ActiveRecord::Base

  attr_accessible :id, :roster_id, :first_name, :last_name, :address1, :address2, :city, :state, :zip,
    :group_id, :male, :youth, :shirt_size, :email, :grade_in_fall, :disclosure_status, :covenant_status,
      :background_status
  scope :youth, (where :youth => 't')
  scope :adult, (where :youth => 'f')

  belongs_to :roster

  validates :roster_id, :first_name, :last_name, :address1, :city, :state, :group_id,
    :shirt_size, :presence => true

  validates :state, :presence => true,
                    :length => { :is => 2}
  validates_inclusion_of :state, :in => State::STATE_ABBREVIATIONS, :message => 'Invalid state.'
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
    youth == 'f' || nil
  end

end
