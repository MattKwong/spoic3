class Ability
  include CanCan::Ability
  # used to authorize program user actions

  def initialize(user)
    if user.liaison?
       liaison = Liaison.find(user.liaison_id)
#      can :manage, Payment
      if liaison then
        can [:edit, :update], Church, :id => liaison.church_id
        can [:read, :edit, :update], Liaison, :id => liaison.id
      end
      groups = ScheduledGroup.find_all_by_liaison_id(user.liaison_id)
      if groups then
        can [:manage], ScheduledGroup, :liaison_id => user.liaison_id
        groups.each do |group|
          roster = Roster.find_by_group_id(group.id)
          can :manage, Roster, :id => group.roster_id
          can :manage, RosterItem, :roster_id => group.roster_id
#        can :read, Payment, :scheduled_group_id => group.id
        end
      end
  #move is defined as being able to move a scheduled group and to increase their numbers
      cannot :move, ScheduledGroup
    end

   if user.staff?
     program_user = ProgramUser.find_by_user_id(user.id)
      can :index, Vendor, :site_id => program_user.program.site_id
      can :manage, Vendor, :site_id => program_user.program.site_id
      can :manage, Item
      can :manage, Program, :id => program_user.program_id
      can :report, Program
  end

  if user.construction_admin?
      can :index, Vendor
      can :manage, Vendor
      can :manage, Item
      can :manage, Program
      can :report, Program
  end

  if user.food_admin?
      can :index, Vendor
      can :manage, Vendor
      can :manage, Item
      can :manage, Program
      can :report, Program
  end

   if user.admin?
     can :manage, :all
   end

    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
