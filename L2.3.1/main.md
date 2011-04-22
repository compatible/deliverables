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

**NB: Cette partie devrait probablement être bougée dans un document commun aux SP du SP2.** 

Pour bien comprendre les enjeux de ce SP, comme d'ailleurs pour la plupart des autres liés au PaaS, il convient de bien distinguer des considérations qui devraient en principes être orthogonales:

- *La gestion des services*: le fait, pour un utilisateur du PaaS, de provisionners un service donné, selon des caractéristiques (resources allouées, SLAs, etc.) qu'il choisit en fonction des besoins de son application; de supprimer ce services (ou de s'en retirer la possibilité de l'utiliser à l'avenir); d'en modifier les caractéristiques à la volée, si cela est possible.

- *L'utilisation des services*: le fait pour une application d'accéder à un ou des services PaaS: CRUD sur un service de persistence, envoi de messages sur un bus de messages, etc.

Mais aussi:

- *Les protocoles* d'accès aux services: à l'exception du runtime qui a un statut à part, les services du PaaS sont accessible selon un protocole client-serveur qui leur est propre, et qu peut être implémenté, côté client, dans n'importe quel langage de programmation.

- *Les APIs* d'accès aux services: selon le langage utilisé (ex: Java, Python...), une ou plusieurs API privilégiées peuvent être fournies aux développeurs, notamment dans le cadre du runtime PaaS, sans que cela constitue une obligation de les utiliser.

Détaillons à présent un peu plus ces différents point.

## La gestion des services

La proposition de valeur du cloud pour les développeurs, c'est, en théorie, de leur permettre de s'abstraire totalement de la gestion des services nécessaires au fonctionnement de leurs applications (SGBD, bus de messages, cache, etc.).

L'expérience (car c'est bien ainsi qu'il faut l'appeler) Google AppEngine montre qu'un PaaS entièrement fondé sur ces principes impose des restrictions considérables aux développeurs -- pas de thread, temps que réponse limité pour chaque requète, modèle de persistence éloigné du modèle relationnel, pas d'accès au filesystème, etc. -- qui rendent l'expérience très contraignante, et pour tout dire insatisfaisante pour la plupart des développeurs.

Force est donc de constater que le terme "PaaS" englobe deux types de services:

- Des services véritablement "internet scale", élastiques, où les développeurs peuvent puiser dans un pool de resources virtuellement infini et son facturés en fonction uniquement de leur usage effectif de ces resources.

  Des exemples de tels services sont Amazon S3, Google BigTable ou le runtime de Google AppEngine.

- Des services à la scalabilité plus limitée, qui impliquent lors de leur instanciation la réservation de resources dédiés (VM, stockage, etc.). 

  Des exemples de tels services sont Amazon RDS ou EC2.

En pratique, on ne peut pas pour des raisons fondamentales, pour un certain nombre de services faire une abstraction totale de la façon dont ceux-ci sont configurés et provisionnés, 

La méthode de gestion des services pour le PaaS 
  
## L'utilisation des services

**TODO**: Détailler.


# Stockage relationnel

Le stockage relationnel est le fondement la majorité des applications d'entreprises depuis une trentaine d'années, et plus récemment, depuis les années 2000 et l'avênement des architecture LAMP (Linux + Apache + MySQL + Perl/Python/PHP) ainsi que de ses variantes (e.g. Mysql + Ruby on Rails) pour les applications web.

L'augmentation du traffic des sites web depuis 10 ans, mais aussi l'apparition de nouveaux modes d'interaction plus participatifs ("Web 2.0") ont entraîné une explosion des besoins sur les SGBDR utilisés dans ce contexte, avec pour conséquence:

- Le développement de mécanismes permettant d'augmenter le point à partir duquel les SGBDR ne peuvent plus suivre (ex: réplication master-slave et master-master) ou de techniques de programmation qui permettent de contourner ces contraintes (ex: sharding).

- Le constat que le modèle relationnel ne permet pas une scalabilité infinie, et qu'il n'est pas non plus adapté à tous les besoins actuels[^0], et l'apparition subséquente de nouveaux modèles, popularisés à présent sous le nom "NoSQL".

[^0]: Michael Stonebraker, *The End of a DBMS Era (Might be Upon Us)*, <http://cacm.acm.org/blogs/blog-cacm/32212-the-end-of-a-dbms-era-might-be-upon-us/fulltext>


## Modèle

Le modèle relationnel est un modèle bien ancré dans un formalisme mathématique [Codd...] et dans des specifications établies de longue date [SQL 98, etc.].

Néanmoins force est de constater que deux SGBDR ne sont jamais interchangeables.

## Implémentations

Deux SBGDR open source sont considérés comme les leaders: MySQL[^1] et Postgresql. 

[^1]: La situation est rendue un peu plus compliquée suite au rachat de Sun par Oracle et aux nombreux forks qui ont suivi: Drizzle, Skysql, MariaDB, etc.

Compte-tenu de ceci, et du fait que les différents SGBDR open source (ou non) du marché présentent des caractéristiques qui les rendent plus ou moins compétitifs selon les applications[^2], il ne paraît pas pertinent d'en choisir un plutôt qu'un autre, mais il convient plutôt à notre sens de donner la possibilité d'utiliser l'un ou l'autre, et plus généralement aux fournisseurs ou au gestionnaire de cloud d'instancier facilement d'autres SGBDR en utilisant un modèle et des API de provisionning similaires.

[^2]: Par exemple, le cas d'utilisation SP4.1 (Nuxeo) exprime une préférence nette pour Postgresql, alors que le cas SP4.2 (XWiki) semble plutôt privilégier MySQL.

## Protocoles

Chaque SGBDR implémente en général son propre protocole, en général binaire pour des raisons d'optimisation.

Il serait illusoire pour le projet Compatible One de proposer un protocole unique indépendant du SGBDR utilisé, d'autant que ça ne résoudrait pas la question des spécificités sous-jacentes.

Il peut cependant être intéressant d'explorer la possibilité d'encapsuler l'accès à ces SGBD dans des appels JSON en HTTP, comme suggéré dans *HTTP JSON AlsoSQL interface to Drizzle*[^3].

[^3]: <http://www.flamingspork.com/blog/2011/04/21/http-json-alsosql-interface-to-drizzle/>.

## API d'utilisation

Paradoxalement, l

En Java:

- JPA (ex: Hibernate)

- DataNucleus.

## API de gestion

 
## Scalabilité

**TODO:** auto-scaling, sharding, réplication, etc.


# Stockage de blobs

Amazon S3 a été, avec EC2, le premier service cloud lancé par Amazon en mars 2006. De fait, 

## Modèle

Le modèle de S3 a été repris à l'identique ou

## Implémentations

TODO: lister les services équivalent (cf. jclouds.org).

-> Swift d'OpenStack ?

## Protocole d'accès

HTTP.

## API d'utilisation

Il existe une librairie qui fournit une couche d'abstraction au dessus d'un stockage de blobs type S3: jclouds[^4]

[^4]: <http://jclouds.org>

## API de gestion

# Stockage post-relationnel (NoSQL)

Les limitations, pour le stockage de volume de données massifs "internet scale", du modèle relationnel ont amené depuis 5 ans un certain nombre de développeurs et de startups à créer de nouveau 

TODO: parle du théorème CAP.

## Modèles

On peut distinguer dans l'écosystème NoSQL quatre grands types de bases:

- Les bases clefs-valeurs. Ex: Tokyo Cabinet, etc.
- Les bases orientées colonnes. Ex: HBase, Cassandra.
- Les bases "orientés documents". Ex: CouchDB, MongoDB, etc.
- Les bases orientées graphes. Ex: Neo4j.

## Implémentations

Encore plus que pour 

## API d'usage

DataNucleus ?


# Service de cache

## Modèle

memcached, ehcache ?

## Implémentations

Idem.

## Protocole d'accès

Protocole memcache.

## API d'usage

jcache ? (cf. google)

## API de gestion

