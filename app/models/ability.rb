# Classe qui gére les droits
class Ability
  include CanCan::Ability

  # Prend en paramètre l'utilisateur actuel (donc rien si c'est juste un visiteur anonyme)
  def initialize(user)
    # Les règles se lisent assez facilement, pour la première :
    # Tout le monde peut lire les petites annonces, les associations, et les événements, ... etc
    can :read, [Classified, Asso, Event]
    can :read, News, :is_moderated => true
    can :read, Document do |obj|
      !obj.documentable.nil? and can?(:read, obj.documentable)
    end
    can :read, Comment do |obj|
      !obj.commentable.nil? and can?(:read, obj.commentable)
    end

    # Si c'est un visiteur anonyme
    if !user
      can :create, User
      can :password_reset, User
    else # C'est un utilisateur connecté
      can :manage, User, :id => user.id

      if user.is_student? # UTTiens ou anciens
        can :read, [Answer, Course, User]
        can [:read, :create], [Asso, Annal, Carpool, Classified, Comment, Event, Project, Poll, Quote, Vote]
        can :create, News

        can [:create, :update, :destroy], Role do |asso|
          asso.nil? and asso.owner_id == user.id
        end

        can [:read, :update], Preference, :user_id => user.id

        can [:join, :disjoin], [Event, Asso]
        can :disjoin, Role # cf dans le controlleur : ce doit être son rôle

        # On ne garde pas l'identité de celui qui met l'annale en ligne,
        # donc elles appartiennent à tout le monde
        can :update, Annal

        # L'auteur peut mettre à jour et supprimer ses contenus
        can [:update, :destroy], [Carpool, Classified, News, Poll, Quote, Vote], :user_id => user.id
        can [:update, :destroy], [Asso, Project, Event], :owner_id => user.id
        can [:update, :destroy], User, :id => user.id
        can [:create, :destroy], Answer do |answer|
          !answer.poll.nil? and can?(:update, answer.poll)
        end
        can [:create, :destroy], Document do |doc|
          !doc.documentable.nil? and can?(:update, doc.documentable)
        end

        can :destroy, Comment, :user_id => user.id

        can :manage, Wiki do |wiki|
          # Pas de rôle (public) ou l'utisateur le rôle requis
          wiki.role.nil? or user.roles.include?(wiki.role)
        end
      end # / student?

      if user.is? :moderator
        can :manage, [Asso, Answer, Annal, Carpool, Classified, Comment, Event, Poll, Quote]
      end
      if user.is? :admin
        can :manage, :all
      end
    end # / user?
  end
end
