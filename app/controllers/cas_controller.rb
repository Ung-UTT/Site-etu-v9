class CasController < ApplicationController
  #load_and_authorize_resource
  before_filter RubyCAS::Filter, :only => :new

  # Essayer de créer une connexion au CAS
  def new
    unless session[:cas_user]
      redirect_to :root, :notice => "Fail :("
    else
      if current_user
        add_cas(current_user)
        redirect_to :root, :notice => "#{session[:cas_user]}, ton compte CAS a été ajouté !"

      elsif @user = User.find_by_login(session[:cas_user])
        add_cas(@user)
        UserSession.create(@user, true)
        redirect_to :root, :notice => "#{session[:cas_user]}, te revoilà !"

      else
        password = password = ActiveSupport::SecureRandom.hex(2) # Exemples : 0ecc 4691 f742 5c03 66c3
        @user = User.create(:login => session[:cas_user], :password => password, 
                            :password_confirmation => password, :cas => true,
                            :email => session[:cas_user] + '@utt.fr')
        UserSession.create(@user, true)
        redirect_to :root, :notice => "#{session[:cas_user]}, ton compte a été créé, ton mot de passe est : " + password + " !"
      end
    end
  end
  
  private
    def add_cas(user)
      unless user.cas
        user.cas = true
        user.save
      end
    end
end
