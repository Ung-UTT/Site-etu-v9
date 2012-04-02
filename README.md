## Si vous êtes un étudiant

Vous devriez aller voir le [wiki](https://github.com/Ung-UTT/Site-etu-v9/wiki).
Si vous voulez reporter un bug, [vous pouvez](https://github.com/Ung-UTT/Site-etu-v9/issues/new).

## Pour les développeurs

Vous pouvez aussi aller voir le [wiki](https://github.com/Ung-UTT/Site-etu-v9/wiki) (et le compléter).
Si vous voulez corriger un bug, [vous pouvez](https://github.com/Ung-UTT/Site-etu-v9/issues).

### Mais voici quelques commandes :

#### Avant de commencer :

Tout le projet utilise des tabulations à 2 espaces, donc veuillez bien à
configurer votre éditeur de texte.
Veuillez aussi respecter les conventions [expliquées ici](http://itsignals.cascadia.com.au/?p=7).

Gardez [les guides](guides.rubyonrails.org) et [l'API](http://api.rubyonrails.org)
ouverts pendant que vous développez.

#### Installation à partir de rien :

Pour **Windows**, installez Linux via VirtualBox, ou autres...
Pour **Mac**, essayez de trouver sur Internet comment installer Rails et rapportez-moi
comment vous avez fait.

Pour **Linux** :

Il faut installer : **Ruby** (le language de programmation que l'on
utilise), **SQlite** (la base de données de développement), **RubyGems**
(pour installer des « gems » (comme des extensions) pour Ruby), **SSH**
(pour communiquer de façon sécurisée via Internet), et **Git** (le
gestionnaire de versions).

Installez les paquets suivants (peut changer suivant votre distribution, ici Ubuntu) :

    ruby ruby1.8-dev ruby-pkg-tools rdoc ri irb libopenssl-ruby sqlite3
    libsqlite3-ruby libsqlite3-dev rubygems1.8 ssh git wget libxslt-dev libxml2-dev

Ajoutez `export PATH=/var/lib/gems/1.8/bin:\$PATH` à la fin de votre ~/.bashrc
puis relancez votre console.

Mettez à jour rubygems : `sudo REALLY_GEM_UPDATE_SYSTEM=1 gem update --system`
(la version d'Ubuntu est vieille).
Puis installez Rails via Rubygems : `sudo gem install rails --no-ri --no-rdoc` (un peu long)
(les options servent à éviter d'installer des trucs inutiles).

Vous allez mettre le code source du site étu sur votre ordi : `git clone https://VOTRE-PSEUDO-GITHUB@github.com/Ung-UTT/Site-etu-v9.git`

Maintenant placez-vous dans le dossier du site étu (`cd Site-Etu-v9`) et faîtes :
`bundle install` (installe les extensions requises)

`rake db:create db:migrate db:fixtures:load db:seed` (Pour créer la base de données
et la remplir de pleins de données fausses, puis de données essentielles)

Voilà, lancez `rails server` et vous devriez voir apparaître le magnifique site
étu sur [localhost:3000](http://localhost:3000). Bravo !

#### Pour Rails :

* Pour créer la base de données avec les bonnes tables toussa… : `rake db:migrate`
* Pour ajouter les utilisateurs de base avec les bons rôles : `rake db:seed`
* Pour lancer le serveur : `rails server`
* Pour lancer la console (permet de faire des tests rapides) : `rails console`

> **Attention** : Détruit toutes les données de la base !

* Pour générer plein de contenu : `rake db:fixtures:load`
* Pour regénérer un environement fonctionnel : `rake dev:reset` (crée des
  base de données pour les environements production, development et test)

#### Pour Git :

* Copier ce dépôt sur votre ordi : `git clone https://VOTRE-LOGIN-GITHUB@github.com/Ung-UTT/Site-etu-v9.git`
* Voilà, maintenant vous modifiez quelques fichiers, bravo, et pour voir vos changements : `git diff`
* Pour ajouter vos changements à un "commit" (lot de changements) : `git add *`
* Pour voir la liste des fichiers modifiés : `git status`
* Pour enregister le "commit" : `git commit` (puis vous écrivez la description des changements)

Puis on l'envoie ici, sur la dépôt central (sur Github) : `git push`.

Si il est refusé, c'est que vous avez déjà fait un commit et qu'entre temps de
nouveaux commits ont été envoyés sur le dépôt central, il faut donc mettre votre
copie du dépôt à jour : `git pull --rebase` (faîtes-le à chaque fois avant
de modifier la branche « master »).

Voilà, et avant de commencer à faire des changements, faîtes `git pull` pour
mettre à jour votre dépôt local.

Si la mise à jour est refusée, alors c'est que vous avez fait des modifications,
faîtes alors `git stash` pour mettre les modifications de côté, puis `git pull`
pour récupérer la dernière version, et enfin `git stash pop` pour remettre vos
modifications.

N'hésitez pas à vous renseigner sur [Git](http://gitref.org/), ses fonctionnalités
sont assez extraordinaires !

#### Les scripts d'import :

##### Le LDAP :

Pour accèder au LDAP (et donc aux informations sur les étudiants) il
faut être à l'UTT ou y accéder via un tunnel SSH (non expliqué ici).

Vous devez lancer le scripts d'imports des étudiants en premier :

* Il va chercher les étudiants sur le LDAP de l'UTT (et les met en cache
dans le fichier vendor/data/ldap.marshal, à supprimer si vous voulez des
infos plus récentes)
* Pour chaque utilisateur trouvé, soit il le crée, soit il le met à jour
* Les attributs enregistrés inclus le nom, le prénom, le niveau, ... etc
mais pas les UVs, cela sera fait via les emploi du temps.

### Tester

Avant d'envoyer votre contribution sur GitHub, assurez-vous que tout les
tests passent avec : `rspec`.

Ou si vous écrivez des tests, utilisez `bundle exec autotest` pour les
faire passer au fur et à mesure que vous les écrivez.

## Licence

Tout les fichiers de ce projet sont sous licence APLGv3.
Voir le fichier LICENSE ou <http://www.gnu.org/licenses/agpl.html>.
