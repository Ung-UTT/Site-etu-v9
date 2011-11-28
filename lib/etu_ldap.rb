# TODO CBA - needs refactoring
require 'net/ldap'

module EtuLdap
  @@ung_auth = {:method => :simple, :username => "cn=Manager,dc=utt,dc=fr", :password => "tototo" } # TODO/FIXME changer le mot de passe et utiliser tls?
  @@ldap = Net::LDAP.new(:host => 'localhost', :port => 1389, :base => "dn:dc=utt,dc=fr", :auth => @@ung_auth)

  def ldap_attributes_for_username(ldap_uid, options={})
    @@ldap.search(:base => "uid=#{ldap_uid.downcase},ou=people,dc=utt,dc=fr") do |entry|
      return flatten_entry(entry)
    end
  end

  def ldap_attribute_for_username(ldap_uid, attr)
    ldap_uid.downcase!
    @@ldap.search(:base => "uid=#{ldap_uid},ou=people,dc=utt,dc=fr", :attributes => ["#{attr}"]) do |e|
      val = e.send("#{attr}")
      return unpack(val)
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
