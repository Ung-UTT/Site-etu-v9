class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, [Classified, Asso, Event]
    can :read, News, :is_moderated => true
    can :read, [Document, Comment] do |obj|
      !obj.documentable.nil? and can?(:read, obj.documentable)
    end

    if !user
      can :create, User
      can :password_reset, User
    else
      can :manage, Reminder, :user_id => user.id
      can :read, User, :id => user.id

      if user.is_student? # UTTiens ou anciens
        can :read, [Album, Course, Question, User]
        can [:read, :create], [Asso, Annal, Carpool, Classified, Comment, Event, Pool, Quote, Vote]
        can :read, Reminder, :user_id => user.id
        can :create, News
        can :read, News, :is_moderated => true

        can [:create, :update, :destroy], Role do |asso|
          asso.nil? and asso.owner_id == user.id
        end

        can [:join, :disjoin], [Event, Asso]
        can :disjoin, Role # cf dans le controlleur : ce doit être son rôle

        # On ne garde pas l'identité de celui qui met l'annale en ligne,
        # donc elles appartiennent à tout le monde
        can :update, Annal

        # L'auteur peut mettre à jour et supprimer ses contenus
        can [:update, :destroy], [Carpool, Classified, News, Pool, Quote, Reminder, Vote], :user_id => user.id
        can [:update, :destroy], [Asso, Project, Event], :owner_id => user.id
        can [:update, :destroy], User, :id => user.id
        can [:create, :destroy], Question do |question|
          !question.pool.nil? and can?(:update, question.pool)
        end
        can [:create, :destroy], Document do |doc|
          !doc.documentable.nil? and can?(:update, doc.documentable)
        end

        can :destroy, Comment, :user_id => user.id
      end # / student?

      if user.is? :moderator
        can :manage, [Asso, Annal, Carpool, Classified, Comment, Event, Pool, Question, Quote]
      end
      if user.is? :admin
        can :manage, :all
      end
    end # / user?
  end
end
