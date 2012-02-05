# app/models/admin_ability.rb

# All back end users (i.e. Active Admin users) are authorized using this class
class AdminAbility
  include CanCan::Ability

  def initialize(user)
#    user ||= AdminUser.new

    if user.admin?
      can :manage, :all
    end

    if user.liaison?
      group = ScheduledGroup.find_by_liaison_id(user.liaison_id)
      roster = Roster.find_by_group_id(group.id)
      user_liaison = Liaison.find(user.liaison_id)
      cannot :manage, [Denomination, Activity, AdjustmentCode, AdminUser,
          BudgetItemType, BudgetItem,  ChangeHistory, ChecklistItem ]

      can [:read, :edit, :update], Church, :id => user_liaison.church_id
      can [:read, :edit, :update], Liaison, :id => user_liaison.id
      cannot [:index, :destroy], [Church, Liaison ]
#      can :update, ScheduledGroup, :liaison_id => user.liaison_id
#      can [:show], RostersController#, :group_id => group.id
    end
  end
end