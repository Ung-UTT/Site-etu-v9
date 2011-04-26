class UserSession < Authlogic::Session::Base
  # FIXME: Pour la compatibilité
  def to_key
    new_record? ? nil : [ self.send(self.class.primary_key) ]
  end
end
