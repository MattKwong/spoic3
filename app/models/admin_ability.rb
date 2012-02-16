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
#TODO: Needs to be modified to cover multiple groups per liaison
      group = ScheduledGroup.find_by_liaison_id(user.liaison_id)
#      roster = Roster.find_by_group_id(group.id)
      liaison = Liaison.find(user.liaison_id)
#      church = Church.find(liaison.church_id)
#      cannot :manage, [Denomination, Activity, AdjustmentCode, AdminUser,
#          BudgetItemType, BudgetItem,  ChangeHistory, ChecklistItem ]
#TODO: The payment restriction isn't working
#      can :read, Payment, :scheduled_group_id => group.id
      can [:read, :edit, :update], Church, :id => liaison.church_id
      can [:read, :edit, :update], Liaison, :id => liaison.id
      cannot [:index, :destroy], [Church, Liaison ]
    end
  end
end