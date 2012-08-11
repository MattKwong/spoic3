class AdminUser < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable,  :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :confirmable, :rememberable, :trackable, :validatable

  belongs_to :site
  belongs_to :user_role

  has_many :programs, :through => :program_users
  has_many :purchases, :foreign_key => "purchaser_id", :dependent => :restrict


  attr_accessible :email, :name, :user_role_id, :first_name, :last_name, :site_id,
                  :liaison_id, :password, :password_confirmation, :remember_me, :admin, :username, :phone

  before_validation do
    unless self.phone.nil?
      if self.phone[0..1] == '1-'
        self.phone[0..1] = ''
      end
      self.phone = self.phone.gsub(/\D/,'')
    end
  end

  validates :email, :uniqueness => true
  validates :username, :uniqueness => true, :allow_blank => true
  validates :first_name, :last_name, :presence => true

  validates_numericality_of :phone,
                      :message => 'Phone number must be 10 digits plus optional separators.',
                      :allow_blank => true

  validates_length_of :phone,
                      :is => 10,
                      :message => 'Phone number must be 10 digits plus optional separators.',
                      :allow_blank => true

  validates_presence_of :liaison_id, :if => :liaison?
  validates_numericality_of :liaison_id, :only_integer => true, :greater_than => 0, :if => :liaison?

  validates_presence_of :site_id, :if => :field_staff?
  validates_numericality_of :site_id, :only_integer => true, :greater_than => 0, :if => :field_staff?
  validates_inclusion_of :site_id, :in => Site.all.map { |s| s.id }, :if => :field_staff?

  before_save :create_name
  before_save :format_phone_numbers

  scope :admin, lambda {
    joins(:user_role).
    where("user_roles.name = ?", 'Admin')}

  scope :liaison, lambda {
    joins(:user_role).
    where("user_roles.name = ?", 'Liaison')}

#  scope :staff, where(self.user_role.name == 'Staff')

    def format_phone_numbers
      unless self.phone.nil? || self.phone == ""
        self.phone = self.phone.insert 6, '-'
        self.phone = self.phone.insert 3, '-'
      end
    end
    def admin?
      self.user_role.name == "Admin"
    end

    def liaison?
      self.user_role.name == "Liaison"
    end

    def area_admin?
      self.user_role.name == "Food Admin" || "Construction Admin" || "Other Admin"
    end

    def food_admin?
      self.user_role.name == "Food Admin"
    end

    def construction_admin?
      self.user_role.name == "Construction Admin"
    end

    def field_staff?
      self.user_role.name == "Staff"
    end

    def staff?
      self.user_role.name == "Staff" || self.area_admin? || self.admin?
    end

    def program_id
      unless ProgramUser.find_by_user_id(self.id)
        0
      else
        ProgramUser.find_by_user_id(self.id).program_id
      end
    end

    def program_user
      ProgramUser.find_by_user_id(self.id)
    end

    def job_name
      job_name = nil
      if self.staff?
        job_name = program_user.job_name
      end
    end

    def slc?
      if self.field_staff?
        program_user.job.job_type.slc?
      else
        false
      end
    end

    def sd?
      if self.field_staff?
        program_user.job.job_type.sd?
      else
        false
      end
    end

    def cook?
      if self.field_staff?
        program_user.job.job_type.cook?
      else
        false
      end
    end

    def construction?
      if self.field_staff?
        program_user.job.job_type.construction?
      else
        false
      end
    end

  def password_required?
  # Password is required if it is being set, but not for new records
    if !persisted?
      false
    else
      !password.nil? || !password_confirmation.nil?
    end
  end

  # new function to set the password without knowing the current password used in our confirmation controller.
  def attempt_set_password(params)
    p = {}
    p[:password] = params[:password]
    p[:password_confirmation] = params[:password_confirmation]
    update_attributes(p)
  end
# new function to return whether a password has been set
  def has_no_password?
    self.encrypted_password.blank?
  end

# new function to provide access to protected method unless_confirmed
  def only_if_unconfirmed
    unless_confirmed {yield}
  end

  scope :not_admin, where(:admin != "Admin")

  scope :current_staff, where(:user_role => "Staff") #, includes(:programs).where('programs.end_date >= ?', Time.now)
#  scope :not_current_staff, includes(:programs).where('programs.end_date < ? OR programs.end_date IS NULL', Time.now)

  scope :search_by_name, lambda { |q|
    (q ? where(["lower(name) LIKE ?", '%' + q.downcase + '%']) : {} )
  }

  def to_s
    name
  end

  def current_program
    program_id
    #self.programs.where("end_date >= ?", Time.now).order('start_date ASC').first
  end

  private
  def create_name
    self.name = self.first_name + ' ' + self.last_name
  end

end
