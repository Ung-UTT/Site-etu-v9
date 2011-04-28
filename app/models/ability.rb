class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, :all
    if user
      can :create, News
      can [:update, :destroy], News, :user_id => user.id
      can [:update, :destroy], User, :id => user.id
      can :destroy, UserSession
    else
      can :create, User
      can [:new, :create], UserSession
    end
  end
end
