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
      can [:join, :disjoin], [Event, Association]
      can :destroy, [UserSession, Authorization]
      can :destroy, Comment, :user_id => user.id

      # TODO ? : Rôles en anglais ?
      if user.is? 'Modérateur'
        can [:update, :destroy], [News, Quote, Event, Classified, Reminder, Comment, Association, Course]

        if user.is? 'Administrateur'
          can :manage, Role

          if user.is? 'SuperAdministrateur'
            can :manage, :all
          end
        end
      end
    end
  end
end
