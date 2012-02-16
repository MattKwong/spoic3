class Ability
  include CanCan::Ability

  def initialize(user)
    if user.liaison?
#TODO: Needs to change to take into account more than one group per liaison

      group = ScheduledGroup.find_by_liaison_id(user.liaison_id)
      liaison = Liaison.find(user.liaison_id)
#      can :manage, Payment
      if liaison then
        can [:edit, :update], Church, :id => liaison.church_id
        can [:read, :edit, :update], Liaison, :id => liaison.id
      end
      if group then
        roster = Roster.find_by_group_id(group.id)
        can [:manage], ScheduledGroup, :liaison_id => user.liaison_id
        can :manage, Roster, :id => group.roster_id
        can :manage, RosterItem, :roster_id => roster.id
#        can :read, Payment, :scheduled_group_id => group.id
      end
  #move is defined as being able to move a scheduled group and to increase their numbers
      cannot :move, ScheduledGroup
 #     cannot :manage, [Activity, BudgetItemType, BudgetItem] #add other resources
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
