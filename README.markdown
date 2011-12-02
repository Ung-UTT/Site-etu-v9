## Si vous êtes un étudiant

Vous devriez aller voir le [wiki](https://github.com/Ung-UTT/Site-etu-v9/wiki).

Si vous voulez reporter un bug, [vous pouvez](https://github.com/Ung-UTT/Site-etu-v9/issues/new).

## Pour les développeurs

Vous pouvez aussi aller voir le [wiki](https://github.com/Ung-UTT/Site-etu-v9/wiki) (et le compléter).

Si vous voulez corriger un bug, [vous pouvez](https://github.com/Ung-UTT/Site-etu-v9/issues).

### Mais voici quelques commandes :

Pour créer la base de données avec les bonnes tables toussa… : `rake db:migrate`

Pour ajouter les utilisateurs de base avec les bons rôles : `rake db:seed`

Pour lancer le serveur : `rails server`

Pour lancer la console (permet de faire des tests rapides) : `rails console`

> **Attention** : Détruit toutes les données de la base !

Pour générer plein de contenu : `rake db:fixtures:load`

Pour regénérer un environement fonctionnel : `rake dev:reset` (crée des
base de données pour les environements production, development et test)

### Tester

Avant d'envoyer votre contribution sur GitHub, assurez-vous que tout les tests passent avec : `rspec`

Ou si vous écrivez des tests, utilisez `bundle exec autotest` pour les faire passer au fur et
à mesure que vous les écrivez.

## Licence

Tout les fichiers de ce projet sont sous licence APLGv3.

Voir le fichier LICENSE ou <http://www.gnu.org/licenses/agpl.html>.

