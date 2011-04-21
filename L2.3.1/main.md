# Besoins

L’objectif de ce service est de fournir trois types de stockage et un service de caching, accessibles sous forme d’API depuis le ou les runtime(s) de la plateforme, et sous forme de service web ou d’un protocole ad-hoc (memcached, thrift, ProtocolBuffer) :

- Stockage relationnel (inspiré par RDS d’Amazon), acessible depuis une API native (ex: MySQL), ou par du REST.

- Stockage de blobs (inspiré par S3 d’Amazon), i.e. espace de stockage d’objets binaires accessibles depuis une API REST.

- Stockage post-relationnel (i.e NoSQL), sous une ou plusieurs formes à déterminer (type SimpleDB d’Amazon, BigTable de Google) comme CouchDB, MongoDB, Cassandra, etc.

- Composant de caching distribué pour permettre aux applications de pouvoir mémoriser de façon temporaire les résultats des computations afin d’ augmenter les performances. Le composant de caching utilisera une API standard comme l’API JCache, utilisée aussi par Google AppEngine, et sera exposé aussi au travers d’une interface REST.

Le travail prévu dans cette sous-tache concernera plutôt l’intégration de solutions de caching existants (comme memcached) et du développement pour les intégrer dans la plate-forme Compatible One.

Chacun de ces stockages devra être autant que possible scalable et distribué, si possible sans nécessité une implication forte des développeurs (séparation des responsabilités).

Les compromis à effectuer et les choix des technologies afférentes, seront réalisés en fonction d’une collecte initiale de besoins auprès des membres du consortium, particulièrement ceux impliqués dans le SP4.

# Architecture générale

Nous pensons que la bonne approche pour ce SP, comme d'ailleurs pour la plupart des autres, est de bien distinguer des considérations qui devraient en 

- La gestion des services

- L'utilisation des services 

## La gestion des services



## L'utilisation des services



# Détail des services proposés 

## Stockage relationnel

Deux SBGDR open source se 

## Stockage de blobs

## Stockage post-relationnel (NoSQL)

## Service de cache

