require 'net/ldap'

module EtuLdap
  @ung_auth = {:method => :simple, :username => "cn=Manager,dc=utt,dc=fr", :password => "tototo" } # TODO/FIXME changer le mot de passe et utiliser tls?
  @ldap = Net::LDAP.new(:host => 'localhost', :port => 1389, :base => "dn:dc=utt,dc=fr", :auth => ung_auth)

  def getDetailsFor(ldap_uid)
    @ldap.search(:base => "uid=#{ldap_uid},ou=people,dc=utt,dc=fr")
    # FIXME find a way to prevent ldap injection
  end
end
