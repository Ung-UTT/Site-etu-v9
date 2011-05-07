class Ability
  include CanCan::Ability

  def initialize(user)
    can [:read, :random], :all
    cannot :read, Reminder
    can [:create, :failure], Authorization

    if user
      can :read, Reminder, :user_id => user.id
      can :create, [News, Quote, Event, Classified, Reminder, Comment]
      can [:update, :destroy], [News, Quote, Classified, Reminder, Carpool], :user_id => user.id
      can [:update, :destroy], Event, :organizer_id => user.id
      can [:update, :destroy], Association, :president_id => user.id
      can [:update, :destroy], User, :id => user.id
      can [:join, :disjoin], [Event, Association]
      can :destroy, [UserSession, Authorization]
      can :destroy, Comment, :user_id => user.id
    else
      can :create, User
      can [:new, :create], UserSession
    end
  end
end
