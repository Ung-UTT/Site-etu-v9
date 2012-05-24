# Classe qui gére les droits
class Ability
  include CanCan::Ability

  # Prend en paramètre l'utilisateur actuel (donc rien si c'est juste un visiteur anonyme)
  def initialize(user)
    # Les règles se lisent assez facilement, pour la première :
    # Tout le monde peut lire les petites annonces, les associations, et les événements, ... etc
    can :read, [Classified, Asso, Event, Quote]
    can :read, News, is_moderated: true
    can :read, Document do |obj|
      obj.documentable and can?(:read, obj.documentable)
    end
    can :read, Comment do |obj|
      obj.commentable and can?(:read, obj.commentable)
    end

    if user # C'est un utilisateur connecté
      can :read, User
      can :manage, User, id: user.id

      if user.has_role? :student # UTTiens ou anciens
        can :read, [Answer, Course, Timesheet]
        can [:read, :create], [Annal, Asso, Carpool, Classified, Comment, Event, Poll, Quote, Vote]

        # News
        can :create, News do |news|
          !news.is_moderated
        end
        can :update, News do |news|
          !news.is_moderated and news.user == user
        end
        can :destroy, News, user: user

        can [:read, :update, :destroy], Project do |project|
          project.users.include?(user)
        end
        can :create, Project

        can [:read, :update], Preference, user: user

        can [:join, :disjoin], [Asso, Event]
        cannot :disjoin, Asso, owner: user

        # L'auteur peut mettre à jour et supprimer ses contenus
        can [:update, :destroy], [Carpool, Classified, Poll, Quote], user: user
        can :update, User, id: user.id
        can [:create, :destroy], Answer do |answer|
          answer.poll and can?(:update, answer.poll)
        end
        can [:create, :destroy], Document do |doc|
          doc.documentable and can?(:update, doc.documentable)
        end

        can :manage, Wiki
      end # / student?

      if user.has_role? :moderator
        can :manage, [Asso, Answer, Carpool, Classified, Comment, Event, News, Poll, Quote]
      end
      if user.has_role? :administrator
        can :manage, :all
      end

      cannot :destroy, User, id: user.id # no suicide please
    end # / user?
  end
end
