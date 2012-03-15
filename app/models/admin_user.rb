class AdminUser < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable,  :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :confirmable, :rememberable, :trackable, :validatable

  belongs_to :site
  belongs_to :user_role

# has_many :program_users, :dependent => :restrict
  has_many :programs, :through => :program_users

  has_many :purchases, :foreign_key => "purchaser_id", :dependent => :restrict

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :name, :user_role_id, :first_name, :last_name, :site_id,
                  :liaison_id, :password, :password_confirmation, :remember_me, :admin, :username

  validates :email, :uniqueness => true
  validates :username, :uniqueness => true
  validates :first_name, :last_name, :presence => true

#  validates_inclusion_of :user_role, :in => UserRole.all.map {|i| i.role_name}

  before_save :create_name

  scope :admin, where(:user_role_id == 1)
#  scope :liaison, where(self.user_role.name == 'Liaison')
#  scope :staff, where(self.user_role.name == 'Staff')

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

    def staff?
      self.user_role.name == "Staff"
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
    self.programs.where("end_date >= ?", Time.now).order('start_date ASC').first
  end

#  def current_job
##    self.program_users.find_by_program_id(self.current_program).job.name
#  end

#  def site_director_for?(program)
#    self.program_users.joins(:job).where(:program_id=>program.id, :job_id => Job.find_by_name("Site Director").id).count == 1
#  end


  private
  def create_name
    self.name = self.first_name + ' ' + self.last_name
  end

end
