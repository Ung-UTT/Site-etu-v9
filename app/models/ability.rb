# Classe qui gére les droits
class Ability
  include CanCan::Ability

  # Prend en paramètre l'utilisateur actuel (donc rien si c'est juste un visiteur anonyme)
  def initialize(user)
    # Les règles se lisent assez facilement, pour la première :
    # Tout le monde peut lire les petites annonces, les associations, et les événements, ... etc
    can :read, [Classified, Asso, Event, Quote]
    can :read, News, :is_moderated => true
    can :read, Document do |obj|
      obj.documentable and can?(:read, obj.documentable)
    end
    can :read, Comment do |obj|
      obj.commentable and can?(:read, obj.commentable)
    end

    # Si c'est un visiteur anonyme
    if !user
      can :create, User
      can :password_reset, User
    else # C'est un utilisateur connecté
      can :manage, User, :id => user.id
      can :show, Role do |role|
        user.is? role
      end

      if user.student? # UTTiens ou anciens
        can :read, [Annal, Answer, Course, User, Timesheet]
        can [:read, :create], [Asso, Carpool, Classified, Comment, Event, Project, Poll, Quote, Vote]
        can :create, News do |news|
          !news.is_moderated
        end

        can :create, Role do |role|
          role.asso.nil? and role.parent.nil?
        end
        can :update, Role do |role|
          role.asso and role.asso.owner == user
        end

        can [:read, :update], Preference, user: user

        can [:join, :disjoin], Event
        can :join, Asso
        can :disjoin, Asso, owner: !user
        # can :disjoin, Role # cf dans le controlleur : ce doit être son rôle

        # L'auteur peut mettre à jour et supprimer ses contenus
        can [:update, :destroy], [Carpool, Classified, News, Poll, Quote], user: user
        can [:update, :destroy], [Asso, Project, Event], owner: user
        can :update, User, id: user.id
        can [:create, :destroy], Answer do |answer|
          answer.poll and can?(:update, answer.poll)
        end
        can [:create, :destroy], Document do |doc|
          doc.documentable and can?(:update, doc.documentable)
        end

        # can :destroy, Comment, user: user

        can :manage, Wiki do |wiki|
          # Pas de rôle (public) ou l'utisateur le rôle requis
          wiki.role.nil? or user.roles.include?(wiki.role)
        end
      end # / student?

      if user.moderator?
        can :manage, [Asso, Answer, Carpool, Classified, Comment, Event, News, Poll, Quote]
      end
      if user.administrator?
        can :manage, :all
      end

      cannot :destroy, User, id: user.id # no suicide please
    end # / user?

    cannot :destroy, Role do |role|
      Role.get_special_role(role.name) # cannot delete special roles
    end
  end
end
