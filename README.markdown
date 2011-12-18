## Si vous êtes un étudiant

Vous devriez aller voir le [wiki](https://github.com/Ung-UTT/Site-etu-v9/wiki).  
Si vous voulez reporter un bug, [vous pouvez](https://github.com/Ung-UTT/Site-etu-v9/issues/new).

## Pour les développeurs

Vous pouvez aussi aller voir le [wiki](https://github.com/Ung-UTT/Site-etu-v9/wiki) (et le compléter).  
Si vous voulez corriger un bug, [vous pouvez](https://github.com/Ung-UTT/Site-etu-v9/issues).

### Mais voici quelques commandes :

#### Avant de commencer :

Tout le projet utilise des tabulations à 2 espaces, donc veuillez bien à configurer votre éditeur de texte.  
Veuillez aussi respecter les conventions [expliquées ici](http://itsignals.cascadia.com.au/?p=7).

#### Pour Rails :

Pour créer la base de données avec les bonnes tables toussa… : `rake db:migrate`  
Pour ajouter les utilisateurs de base avec les bons rôles : `rake db:seed`  
Pour lancer le serveur : `rails server`  
Pour lancer la console (permet de faire des tests rapides) : `rails console`

> **Attention** : Détruit toutes les données de la base !

Pour générer plein de contenu : `rake db:fixtures:load`  
Pour regénérer un environement fonctionnel : `rake dev:reset` (crée des
base de données pour les environements production, development et test)  

#### Pour Git :

Copier ce dépôt sur votre ordi : `git clone https://VOTRE-LOGIN-GITHUB@github.com/Ung-UTT/Site-etu-v9.git`  
Voilà, maintenant vous modifiez quelques fichiers, bravo, et pour voir vos changements : `git diff`  
Pour ajouter vos changements à un "commit" (lot de changements) : `git add *`  
Pour voir la liste des fichiers modifiés : `git status`  
Pour enregister le "commit" : `git commit` (puis vous écrivez la description des changements)

Puis on l'envoie ici, sur la dépôt central (sur Github) : `git push`
Si il est refusé, c'est que vous avez déjà fait un commit et qu'entre temps de nouveaux commits ont été envoyés sur le dépôt
central, il faut donc mettre votre copie du dépôt à jour : `git pull --rebase`.

Voilà, et avant de commencer à faire des changements, faîtes `git pull` pour mettre à jour votre dépôt local.  
Si la mise à jour est refusée, alors c'est que vous avez fait des modifications, faîtes alors `git stash`
pour mettre les modifications de côté, puis `git pull` pour récupérer la dernière version, et enfin `git stash pop`
pour remettre votre modifications.

N'hésitez pas à vous renseigner sur [Git](http://gitref.org/), ses fonctionnalités sont assez extraordinaires !

### Tester

Avant d'envoyer votre contribution sur GitHub, assurez-vous que tout les tests passent avec : `rspec`
Ou si vous écrivez des tests, utilisez `bundle exec autotest` pour les faire passer au fur et
à mesure que vous les écrivez.

## Licence

Tout les fichiers de ce projet sont sous licence APLGv3.
Voir le fichier LICENSE ou <http://www.gnu.org/licenses/agpl.html>.
