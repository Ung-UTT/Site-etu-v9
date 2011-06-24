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

      # TODO: Seul celui qui a créé le "documentable" peut y ajouter un document
      can :create, [Annal, Association, Classified, Comment, Course, Document, Event, News, Project, Quote, Reminder]
      can :create, Document do |doc|
        if doc.documentable.nil?
          false
        else
          can? :create, documentable
        end
      end
      # L'auteur peut mettre à jour et supprimer ses contenus
      can [:update, :destroy], [Carpool, Classified, News, Quote, Reminder], :user_id => user.id
      can [:update, :destroy], Association, :president_id => user.id
      can [:update, :destroy], [Course, Project], :owner_id => user.id
      can [:update, :destroy], Event, :organizer_id => user.id
      can [:update, :destroy], User, :id => user.id

      can [:create, :update, :destroy], Role do |association|
        # Si le rôle est associé à une association alors seul le président peut créer, mettre à jour ou supprimer les rôles
        association == nil ? association.president_id == user.id : false
      end
      can [:join, :disjoin], [Event, Association]
      can :destroy, [UserSession, Authorization]
      can :destroy, Comment, :user_id => user.id
      can :destroy, Document do |doc|
        if doc.documentable.nil?
          false # Seul les admins peuvent supprimer les documents associés à aucun contenu
        else
          can? :destroy, documentable
        end
      end
      can :destroy, Role do |role|
        # TODO: on ne peut pas utiliser params['user_id'] donc comment
        #       faire pour qu'un utilisateur puisse supprimer ses roles
        #       associés (et pas le rôle en entier)
        #       (pas dans controlleur)
        false
      end

      if user.is? :moderator
        can [:update, :destroy], [Annal, Classified, Comment, Event, News, Quote]
      end
      if user.is? :admin
        can :manage, [Role, Group]
      end
      if user.is? :superAdmin
        can :manage, :all
      end
    end
  end
end
