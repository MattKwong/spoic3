# app/models/admin_ability.rb

# All back end users (i.e. Active Admin users) are authorized using this class
class AdminAbility
  include CanCan::Ability

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
      can :index, Vendor #, :site_id => user.program_user.program.site_id
      can :manage, Vendor #, :site_id => user.program_user.program.site_id
      can :index, Item
      can :manage, Item
      can :manage, Program #, :id => user.program_user.program_id
#      can :report, Program
    end
    if user.construction_admin?
      can :manage, ProjectType
      can :manage, ProjectCategory
      can :manage, ProjectSubtype
      can :manage, StandardItem
    end
    if user.construction_admin? || user.food_admin?
      can :manage, Item
      can :manage, ItemType
      can :manage, ItemCategory
    end

    if user.admin?
      can :manage, :all
    end

  end
end