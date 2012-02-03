# app/models/admin_ability.rb

# All back end users (i.e. Active Admin users) are authorized using this class
class AdminAbility
  include CanCan::Ability

  def initialize(user)
    user ||= AdminUser.new

    if user.admin?
      can :manage, :all
    end

    if user.liaison?
      group = ScheduledGroup.find_by_liaison_id(user.liaison_id)
      roster = Roster.find_by_group_id(group.id)
#      liaison = Liaison.find_by_email1(user.email)
      cannot :read, Denomination
      cannot :read, Activity
      can [:read, :edit], Church #, :liaison_id => user.liaison_id
      can :update, ScheduledGroup, :liaison_id => user.liaison_id
      can [:read, :edit, :create], RosterController, :group_id => group.id
    end
  end
end