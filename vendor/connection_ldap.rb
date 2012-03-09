# encoding: UTF-8
# TODO - command line output of what has been done
# TODO - handle command params for a verbose output
# TODO - handle errors
# TODO - auto-remove stale .ldif files (older than 10 days)
require 'rubygems'
require 'net/ldap'
require 'date'

# Accès au ldap du cri periodiquement afin de mettre à jour le ldap site étu
# ATTENTION : Assurez vous de bien comprendre TOUT ce que fait le script avant de le modifier. 
# Avant de changer quoi que ce soit ici, assurez vous de :
# * avoir bien compris le fonctionnement du protocole LDAP
# * avoir analysé la structure des schémas du LDAP de l'UTT et de celui de l'UNG
# Des mauvais changements ici pourraient rendre le LDAP de l'UNG inutilisable et donc perturber l'utilisation du trombi, profil ou autres modules l'utilisant.

# Ajouter les éventuels nouveaux attributs nécessaires ici (vérifiez que le schéma définissant ces attibuts est inclut). Mettre a jour REQUIRED_OBJECT_CLASSES en conséquence
ATTRIBUTES = %w[dn uid supannAliasLogin uv cn sn givenName displayName mail eduPersonPrincipalName supannParrainDN supannEmpId supannEtuId businessCategory supannAffectation telephoneNumber title roomNumber formation niveau filiere employeeType eduPersonAffiliation eduPersonAffiliation jpegPhoto objectClass ou]

# Liste des objectclasses nécéssaires pour utiliser les attributs définit dans ATTRIBUTES. Se référerer aux schémas (/etc/ldap/*.schema) pour plus d'info, ou en ajouter de nouvelles. Il est aussi possible d'ajouter de nouveaux schémas
REQUIRED_OBJECT_CLASSES = %w[inetOrgPerson supannPerson eduPerson UTT top alias country locality organization organizationalUnit person organizationalPerson organizationalRole groupOfNames groupOfUniqueNames]

# Nom du fichier ldif généré pour l'ajout des nouveaux membres
LDIF_FILE = "#{Date.today}-people-new.ldif"

def ldap_routine
  # Connection aux deux annuaires LDAP
  # TODO/FIXME virer les port et hosts foireux utilisés pour tester le script depuis l'ext
  ldap_utt = Net::LDAP.new(:host => 'localhost', :port => 389, :base => "dn:dc=utt,dc=fr")
  ung_auth = {:method => :simple, :username => "cn=Manager,dc=utt,dc=fr", :password => "tototo" } # TODO/FIXME changer le mot de passe et utiliser tls?
  ldap_ung = Net::LDAP.new(:host => 'localhost', :port => 1389, :base => "dn:dc=utt,dc=fr", :auth => ung_auth)
  puts "ca bind : " + ldap_ung.bind.inspect

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

  # création de l'ou people si besoin
  people_attr = {
    :ou => "people",
    :objectclass => ["top", "organizationalUnit"]
  }
  ldap_create_node(ldap_ung, "ou=people,dc=utt,dc=fr", people_attr)
  # TODO Voir si on fait des ou pour des groupes ou quoi…

  ########################################################################
  # ETAPE 2 - Réplication des informations du LDAP UTT sur celui du site étu
  ########################################################################
  ung_names = []
  updated_entries = []

  # On récupère tous les noms d'utilisateurs présents dans le ldap site étu
  ldap_ung.search(:base => 'ou=people,dc=utt,dc=fr', :attributes => ['uid']) do |person|
    ung_names << person['uid']
  end
  puts "-> Liste des etudiants presents dans le ldap UNG etablie"

  puts "-> Generation des fichiers ldif..."
  # On crée le fichier .ldif qui sera utilisé pour mettre à jour le LDAP
  ldif_new_users = File.open(::LDIF_FILE, 'w')
  # On boucle sur toutes les personnes du ldap de l'UTT pour faire les mises à jour nécessaires
  ldap_utt.search(:base => 'ou=people,dc=utt,dc=fr', :attributes => ::ATTRIBUTES) do |person|
    if ung_names.include?(person['uid'])
      updated_entries << person # On met ça de coté pour mettre à jour les attributs do la personne dans le ldap de l'ung
    else
      # Nouvelle recrue
      ldif_new_users << person.to_ldif
      ldif_new_users << "\n"
    end
    print '.'
    STDOUT.flush
  end
  ldif_new_users.close

  # On vire les object class en trop qu'il y a dans le fichier généré
  remove_unused_oc(::LDIF_FILE)

  # On applique les changements au ldap de l'ung
  ldap_ung.open do |ldap|
    ldap_update_attributes(updated_entries, ldap)
    ldap_add_entities(::LDIF_FILE, ldap)
  end

  # TODO Don't forget to remove files that are older than 10 days
end

def ldap_update_attributes(updated_entries, obsolete_ldap)
  # Si la personne est dans le LDAP de l'UNG, on vérifie que toutes ses informations sont à jour
  # Pour tous les attrs qui sont dans les deux annuaire, vérifier valeur sinon maj valeur
  updated_entries.each do |person|
    person.attribute_names.each do |att|
      unless %w[dn objectclass].include? att.to_s.downcase
        obsolete_ldap.replace_attribute(person.dn, att, person.send(att))
        puts "Mise à jour de  #{person.dn} pour l'attribut #{att}: #{obsolete_ldap.get_operation_result.code} - #{obsolete_ldap.get_operation_result.message}"
      end
    end
  end
end

def ldap_create_node(ldap, dn, attributes)
  node = ldap.search(:base => dn, :attr => ['dn'], :return_result => false)
  puts dn + " " + node.inspect
  # creation du nœud racine si besoin
  if node != false
    puts 'the "' + dn + '" dn exists'
  else
    puts '"' + dn + '" does not exist, creating...'
    ldap.add(:dn => dn, :attributes => attributes)
  end
end

# Fait passer un étudiant qui n'est plus dans le LDAP du cri en ancien étudiant
def ldap_set_alumni(student_dn)
  # TODO
end

# Ajoute une nouvelle personne dans l'annuaire site étu
def ldap_add_entities(ldif_dump, ldap)
  puts "Ajout des entrées:"
  # on crée un nouveau fichier en filtrant les objectclasses pour garder que ceux qu'on veut
  f= File.open(ldif_dump, "r")
  people = Net::LDAP::Dataset.read_ldif(f)

  people.each do |entry|
    ldap.add(:dn => entry[0], :attributes => entry[1])
    puts "Ajout de  #{entry[0]}: #{ldap.get_operation_result.code} - #{ldap.get_operation_result.message}"
  end
end

# Supprime les ObjectClass non désirés des fichiers .ldif
def remove_unused_oc(file)
  fbk = file + ".bak"
  File.rename(file, fbk)
  File.open(file, "w") do |out|
    # on crée un nouveau fichier en filtrant les objectclasses pour garder que ceux qu'on veut
    File.foreach(fbk) do |line|
      out.puts line if (!line.downcase.include?("objectclass") || ::REQUIRED_OBJECT_CLASSES.any? {|oc| line.downcase.include?(oc.downcase)}) #désolé :P
    end
  end
  File.delete(fbk)
end

ldap_routine
