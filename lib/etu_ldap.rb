# TODO CBA - needs refactoring
require 'net/ldap'

module EtuLdap
  # TODO/FIXME changer le mot de passe et utiliser tls?
  @@ung_auth = {:method => :simple, :username => "cn=Manager,dc=utt,dc=fr", :password => ENV["LDAP_PASSWORD"] }
  # FIXME: Le port 1389 est seulement là pour les tests (via le VPN)
  # En production c'est le port 389
  @@ldap = Net::LDAP.new(:host => 'localhost', :port => 1389, :base => "dn:dc=utt,dc=fr", :auth => @@ung_auth)

  def ldap_attributes_for_username(ldap_uid, options={})
    unless @@ldap.nil?
      begin
        @@ldap.search(:base => "uid=#{ldap_uid.downcase},ou=people,dc=utt,dc=fr") do |entry|
          return flatten_entry(entry)
        end
      rescue => e
        @@ldap = nil
      end
    end
  end

private

  def flatten_entry(entry)
    flattened_hash = Hash.new
    entry.each {|attr,val| flattened_hash[attr.to_s] = unpack(val)}
    flattened_hash
  end

  def unpack(val)
    (val.is_a?(Array) && val.size == 1) ? val.to_s : val
  end
end
