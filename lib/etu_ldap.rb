require 'net/ldap'

module EtuLdap
  @@ung_auth = {:method => :simple, :username => "cn=Manager,dc=utt,dc=fr", :password => "tototo" } # TODO/FIXME changer le mot de passe et utiliser tls?
  @@ldap = Net::LDAP.new(:host => 'localhost', :port => 1389, :base => "dn:dc=utt,dc=fr", :auth => @@ung_auth)

  def ldap_attributes_for_username(ldap_uid, options={})
    ldap_uid.downcase!
    @@ldap.search(:base => "uid=#{ldap_uid},ou=people,dc=utt,dc=fr")
    # FIXME find a way to prevent ldap injection
  end

  def ldap_attribute_for_username(ldap_uid, attr)
    ldap_uid.downcase!
    @@ldap.search(:base => "uid=#{ldap_uid},ou=people,dc=utt,dc=fr", :attributes => ["#{attr}"]) do |e|
      return e.send("#{attr}").first||nil
    end
  end
end

# class User
#   include EtuLdap
#   attr_accessor 'username'
# 
#   def initialize(username)
#     @username = username
#   end
#   
#   def ldap_attributes
#     ldap_attributes_for_username(@username).first
#   end
# 
#   def ldap_attribute(attr)
#     ldap_attribute_for_username(@username, attr)
#   end
# end
# 
# u = User.new("wormsern")
# puts u.username
# 
# puts u.ldap_attributes.inspect
# puts "----------"
# puts u.ldap_attribute("")
