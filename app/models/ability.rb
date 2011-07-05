class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, [Classified, Association, Event]
    can :read, News, :is_moderated => true
    can [:create, :failure], Authorization

    if !user
      can :create, [User, UserSession]
      can :password_reset, User
    else
      can :read, Reminder, :user_id => user.id

      if user.is_student? or !user.roles.empty? # UTTiens ou anciens
        can [:read, :create], :all
        cannot :read, Reminder
        can :read, Reminder, :user_id => user.id

        cannot :create, [Role, Group, Document]
        can [:create, :destroy], Document do |doc|
          doc.documentable.nil? ? false : can?(:update, doc.documentable)
        end

        can [:create, :update, :destroy], Role do |association|
          association == nil ? association.owner_id == user.id : false
        end

        can [:join, :disjoin], [Event, Association]
        can :disjoin, Role # cf dans le controlleur : ce doit être son rôle

        # L'auteur peut mettre à jour et supprimer ses contenus
        can [:update, :destroy], [Carpool, Classified, News, Quote, Reminder], :user_id => user.id
        can [:update, :destroy], [Association, Project, Event], :owner_id => user.id
        can [:update, :destroy], User, :id => user.id

        can :destroy, UserSession
        can :destroy, [Authorization, Comment], :user_id => user.id

        if user.is? :moderator
          can :manage, [Association, Annal, Classified, Comment, Event, News, Quote]
        end
        if user.is? :admin
          can :manage, [Role, Group]
        end
        if user.is? :superAdmin
          can :manage, :all
        end
      end # / student?
    end # / user?
  end
end
