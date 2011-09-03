require 'rubygems'
require 'net/ldap'

# Accès au ldap du cri periodiquement afin de mettre à jour le ldap site étu
# ATTENTION : Assurez vous de bien comprendre TOUT ce que fait le script avant de le modifier. 
# Avant de changer quoi que ce soit ici, assurez vous de :
# * avoir bien compris le fonctionnement du protocole LDAP
# * avoir analysé la structure des schémas du LDAP de l'UTT et de celui de l'UNG
# Des mauvais changements ici pourraient rendre le LDAP de l'UNG inutilisable et donc perturber l'utilisation du trombi, profil ou autres modules l'utilisant.

def ldap_routine
    # Connection aux deux annuaires LDAP
    ldap_utt = Net::LDAP.new(:host => 'ldap.utt.fr', :port => 389, :base => "dn:dc=utt,dc=fr")
    ung_auth = {:method => :simple, :username => "cn=Manager,dc=utt,dc=fr", :password => "tototo" }
    ldap_ung = Net::LDAP.new(:host => 'localhost', :port => 389, :base => "dn:dc=utt,dc=fr", :auth => ung_auth)
    puts "ça bind : " + ldap_ung.bind.inspect

    ########################################################################
    # ETAPE 1 -  Création des nœuds de niv 1 et 2 si besoin (la première fois)
    ########################################################################
    # creation du nœud racine si besoin
    root_attr = {
        :o => "UTT", 
        :dc => "UTT", 
        :objectclass => ["top", "dcObject", "organization"]
    }
    ldap_create_node(ldap_ung, "dc=utt,dc=fr", root_attr)
    # creation de l'ou people si besoin
    people_attr = {
        :ou => "people",
        :objectclass => ["top", "organizationalUnit"]
    }
    ldap_create_node(ldap_ung, "ou=people,dc=utt,dc=fr", people_attr) 
    # Voir si on fait des ou pour des groupes ou quoi…
=begin
    ########################################################################
    # ETAPE 2 - Réplication des informations du LDAP UTT sur celui du site étu
    ########################################################################
    utt_names = []
    ung_names = []
    #
    # On récupère tous les noms d'utilisateurs présents dans le ldap site étu
    # puts ldap_ung.inspect
    ldap_ung.search(:base => 'ou=people,dc=utt,dc=fr', :attributes => ['uid']) do |person|
        ung_names += person['uid']
    end
    puts "############ UNG NAMES ##############"
    puts ung_names

    # On boucle sur toutes les personne du ldap de l'UTT pour faire les mise à jour nécessaires
    ldap_utt.search(:base => 'ou=people,dc=utt,dc=fr', :attributes => ['uid']) do |person|
        utt_names += person['uid']
        # Si la personne est dans le LDAP de l'UNG, on vérifie que toutes ses informations sont à jour
            ## Pour tous les attrs qui sont dans les deux annuaire, vérifier valeur sinon maj valeur
        # Sinon c'est une nouvelle recrue, on l'ajoute au LDAP de l'UNG
    end
    puts "############ UTT NAMES ##############"
    puts utt_names
=begin
    # On recherche dans la base de donnée pour voir si les noms sont présents dedans
    # équivalent ldapsearch : ldapsearch -x -b "ou=people,dc=utt,dc=fr" -H ldap://ldap.utt.fr -LLL dn uid supannAliasLogin uv cn sn givenName displayName mail eduPersonPrincipalName supannParrainDN supannEmpId supannEtuId businessCategory supannAffectation telephoneNumber title roomNumber formation niveau filiere employeeType eduPersonAffiliation eduPersonAffiliation jpegPhoto objectClass ou
     ldap.search(:base => 'ou=people,dc=utt,dc=fr', :attributes => ['uid'], :return_result => true) do |entity|
        # puts entity.inspect
        entity.each do |attr, values|
            if values.first not in name_list
                ldap_add_entity (values.first.dn)
            end
        end
    end
=end
end

def ldap_create_node(ldap, dn, attributes)
    node = ldap.search(:base => dn, :attr => ['dn'], :return_result => false)
    puts dn + " " + node.inspect
    # creation du nœud racine si besoin
    if node != false
       puts 'the "' + dn + '" exists'
    else
       puts '"' + dn + '" does not exist, creating…' 
       ldap.add(:dn => dn, :attributes => attributes)
    end
end

# Fait passer un étudiant qui n'est plus dans le LDAP du cri en ancien étudiant
def ldap_set_alumni(student_dn)

end

# Ajoute une nouvelle personne dans l'annuaire site étu
def ldap_add_entities(ldif_dump)

end


# recherche des étudiants
def ldap_search

    #ldap = Net::LDAP.new
    #ldap.host = "ldap.utt.fr"
    #ldap.port = "389"

    # ldap.auth "cn=anonymous", ""

    #  filter = Net::LDAP::Filter.eq( "ou", "people" )
    #attrs = [ "uid" , "objectClass"]
=begin
    puts "before loop"
    all = ldap.search(:base => 'ou=people,dc=utt,dc=fr', :return_result => true) do |entry|
        # puts entry.inspect
        puts "DN: #{entry.dn}"
        entry.each do |attr, values|
            puts ".......#{attr}:"
            values.each do |value|
                puts "          #{value}"
            end
        end
    end
=end
    # all = ldap.search(:base => 'ou=people,dc=utt,dc=fr')
    # all.each {|entry| puts entry.inspect}
end 

ldap_routine
