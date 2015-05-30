# HubDocker Webhook
Webservice permettant de répondre à un webhook du hub docker afin de relancer un conteneur avec une nouvelle version de l'image.

## Developpement

Spécifier la variable d'environnement `SECURITY_TOKEN`.

Démarrer la stack avec `bundle exec foreman start`. Ceci démarre un serveur Redis, un daemon Sidekiq et l'app Sinatra qui répond sur le port 9292.

Il est possible de tester en appelant l'url en POST. Avec [httpie](https://github.com/jakubroztocil/httpie) par exemple :

    $ http POST http://localhost:9292/$SECURITY_TOKEN < payload-example.json
