class Ability
  include CanCan::Ability

  def initialize(user)
    can [:read, :random], :all
    if user
      can :create, [News, Quote, Event]
      can [:update, :destroy], [News, Quote], :user_id => user.id
      can [:update, :destroy], Event, :organizer_id => user.id
      can [:update, :destroy], User, :id => user.id
      can [:join, :disjoin], Event
      can :destroy, UserSession
    else
      can :create, User
      can [:new, :create], UserSession
    end
  end
end
