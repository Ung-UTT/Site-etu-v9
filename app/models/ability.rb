class Ability
  include CanCan::Ability

  def initialize(user)
    can [:read, :random], :all
    cannot :read, Reminder
    can [:create, :failure], Authorization

    if !user
      can :create, User
      can [:new, :create], UserSession
    else
      can :read, Reminder, :user_id => user.id
      can :create, [News, Quote, Event, Classified, Reminder, Comment, Association, Course]
      can [:update, :destroy], [News, Quote, Classified, Reminder, Carpool], :user_id => user.id
      can [:update, :destroy], Association, :president_id => user.id
      can [:update, :destroy], Course, :owner_id => user.id
      can [:update, :destroy], Event, :organizer_id => user.id
      can [:update, :destroy], User, :id => user.id
      can [:update, :destroy], Role do |association|
        association == nil ? association.president_id == user.id : false
      end
      can [:join, :disjoin], [Event, Association]
      can :destroy, [UserSession, Authorization]
      can :destroy, Comment, :user_id => user.id
      can :destroy, Role do |role|
        # TODO: on ne peut pas utiliser params['user_id'] donc comment
        #       faire pour qu'un utilisateur puisse supprimer ses roles
        #       associés (et pas le rôle en entier)
        false
      end

      # TODO ? : Rôles en anglais ?
      if user.is? :moderator
        can [:update, :destroy], [News, Quote, Event, Classified, Reminder, Comment, Association, Course]
      end
      if user.is? :admin
        can :manage, Role
      if user.is? :superAdmin
      end
          can :manage, :all
      end
      end
  end
end
