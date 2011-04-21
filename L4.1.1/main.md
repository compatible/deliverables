# Expression des besoins 

Cette section décrit les principaux enjeux de la cloudification d'une plateforme d'ECM comme Nuxeo et de son écosystème d'applications métiers, horizontales et verticales.

Les trois objectifs primaires pour les démonstrateurs du SP4.1 sont:
  
- Meilleure intégration dans un écosystème cloudifié : l’objectif ici est d’industrialiser le déploiement d’applications Nuxeo "stock" dans le Cloud, en se basant sur des outils et des services standard ou génériques, plutôt que sur des outils ad-hoc. Un tel développement peut se faire par étapes, en partant des couches inférieures, et en remplaçant les services existants du Cloudware et de la plate-forme Nuxeo par des services génériques de l’IaaS et du PaaS Compatible One.

- "Nuxeo Document Storage as a Service", aka "Elastic CMIS" : si, comme nous le prévoyons, le standard CMIS connait une adoption rapide à l’horizon 2011-2012, nous pensons qu’il pourrait y avoir un intérêt pour du stockage CMIS “on demand” et infiniment élastique. Le contenu ainsi stocké et manipulé pourrait être consommé via des aplications clientes (MS-Office, applications métiers), ou en ligne via des mashups.

-  Nuxeo App Store for CEVAs : la troisième étape cible serait de permettre à des éditeurs d’applications verticales orientées contenu de construire des applications par dessus le CMIS élastique, soit en tant que process indépendants, soit en tant qu’applications directement intégrées dans la base documentaire (mais en multi-tenant). Outre la réalisation des applications, le principal challenge est la mise sur le marché de ces applications, avec la vision d’un “App Store” dédié à la plate-forme.
 
## Cloudification des applications Nuxeo

### Contexte

Nuxeo a développé un certain nombre d’applications, horizontales et
verticales, comme Nuxeo DM (Document Management), Nuxeo DAM (Digital
Asset Management) et Nuxeo Courrier (Gestion de courrier et des cas
métier), dédiées à la gestion documentaire.

Ces applications sont actuellement packagées sous la forme d’un serveur
d’applications Java EE (ex: Tomcat, JBoss, Jetty) enrichi par un
environnement “OSGi-like” et d’un ensemble de composants qui
implémentent les services Nuxeo. Un ensemble de fichiers XML permet de
décrire l’assemblage de ces composants et leur paramêtrage. Cet
environnement d’exécution Java doit être complété par un certain nombre
de services: SGBR (ex: PostgreSQL), moteur de rendu de fichier
bureautique (ex: OpenOffice.org en mode “headless”), outil de
tranformation d’images (ex: ImageMagik), outil de tranformation video
(ex: ffmpeg), etc.

L’ensemble de ces serveurs et outils sont en générale packagés dans des
VM, afin de garantir une bonne isolation entre les applications des
différents utilisateurs.

Ce mode de déploiement présente plusieurs défis:

-   *scaling down*: la taille minimale d’une VM contenant une instance
    de Nuxeo, pour avoir des performances décentes pour une utilisation
    non intensive par quelques dizaines d’utilisateurs est de 2 Go.
    Proposer des applications pour les très petits utilisateurs (TPE) ou
    des versions d’essais n’est économiquement rentable que si on passe
    par une approche où plusieurs clients sont hébergés dans la même VM,
    et même dans la même JVM (i.e. le même serveur d’appli), ce qui
    oblige à passer par une approche multi-tenant.

-   *scaling up*: un utilisateur ayant des gros besoins devra utiliser
    des VM plus importantes (\> 10 Go de RAM, CPU multi-cores
    puissants), jusqu’à un point où seule une installation
    multi-serveurs est capable de répondre aux besoins. Dans ce cas,
    plusieurs VM doivent être provisionnées, selon plusieurs templates
    (base de données, repository, transformation, frontaux), en fonction
    du besoin du client.

-   *tolérance aux pannes*: un déploiement mono-serveur est sensible aux
    pannes matérielles ou logicielles, il convient d’introduire de la
    redondance et des mécanismes de fail-over si on souhaite garantir
    aux utilisateurs

Plus généralement, les besoins d’un client peuvent évoluer et c’est une
des propositions de valeur du cloud computing de permettre aux
utilisateurs d’adapter le dimensionnement de leur application en
fonction de l’évolution de leurs besoins.

### Objectifs

Disposer de prototypes des applications Nuxeo sous une forme exploitant
une partie plus ou moins importante des fonctionnalités de Compatible
One (IaaS seul, IaaS + PaaS, PaaS seul), de façon à les benchmarker et
pouvoir évaluer la pertinence d’en dériver ultérieurement des produits
finis.

### Challenges

-   Démontrer la pertinence des outils du SP1 (IaaS) pour le
    provisionning et la gestion de machines et de stockage virtualisés.
-   Démontrer la pertinence des services la plateforme SP2 (PaaS), en
    particulier.
    -   Le runtime OSGi.
    -   Le stockage (des métadonnées et des BLOBs).
    -   Le service de gestion documentaire qui sera lui-même une
        abstraction des services Nuxeo bas niveau (Nuxeo Core).

### Principales tâches

-   Utiliser les outils de SP1.2 (Administration de machines virtuelles)
    pour provisionner et administrer des machines virtuelles contenant
    des instances des applications Nuxeo.

-   Utiliser les outils de SP1.3 (Système de stockage distribué à haute
    disponibilite) et/ou SP2.3 (Service de stockage et de caching) pour
    stocker et cacher les informations de bas niveau nécessaires aux
    fonctionnement du repository Nuxeo, mais aussi pour s’assurer d’un
    niveau correct (garanti par SLA) de sécurité des données des
    utilisateurs.

-   Utiliser le SP 2.4 (Runtime OSGI) pour découper les applications
    Nuxeo (qui sont déjà modularisées sous forme de bundles OSGi) en
    services indépendants.

-   Faire évoluer, grâce au SP2.6 (API-gestion documentaire), les
    logiciels Nuxeo vers le multi-tenant.

-   Utiliser les outils de SP2.1 (PaaS Scheduling, Calcul Distribué)
    pour les calculs intensifs comme par exemple le rendering
    (transformation des documents en PDF) ou le text-mining sémantique.

-   Utiliser les outils du SP2.5 (Comptabilisation, inscription et
    facturation) afin de rentre la commande et le déploiement des
    applications simple pour les utilisateurs et pour proposer un mode
    de facturation “à la demande” qui soit à la fois attractif pour
    l’utilisateur mais également créateur de valeur pour Nuxeo.

-   Utiliser les outils du SP3 pour s’assurer de la qualité de service,
    de la sécurité, etc.

### Use cases et contraintes pour les autres SP

-   SP1.2: TODO tiry.

-   SP1.3 et SP2.3: doivent fournir soit un filesystème “infiniment”
    élastique, soit un service de stockage de binaires (BLOBs) à la S3.

-   SP2.4: doit fournir un environnement d’exécution de services OSGi
    scalable, managé, etc. Ce service pourrait être comparable à ce que
    proposent Paremus Service Fabric (<http://www.paremus.com>) ou bien
    le PaaS d’Intalio (<http://www.intalio.com/osgi>).

-   SP2.6: doit fournir les services “core” de Nuxeo sous une forme
    totalement multitenant (isolation des repositories, des utilisateurs
    et des customisations) dans un même environnement d’exécution OSG
    (SP2.4).

-   SP2.5: doit permettre la comptabilisation des ressources IaaS et
    PaaS consommées par les applications Nuxeo.

-   SP2.1: permettre l’exécution de jobs asynchrone de type MapReduce et
    GridGain (TODO tiry).

## Cloudification d’application verticales tierces

### Contexte

Nuxeo souhaite encourager le développement d’applications verticales
au-dessus de sa plateforme, par des développeurs tiers.

Afin de rendre cette approche attractive pour les développeurs, Nuxeo
souhaite proposer une approche intégrée, depuis le développement
jusqu’au déploiement des applications, en passant par la facturation et
le paiement par les utilisateurs, avec partage des revenus entre Nuxeo
et les développeurs tiers.

Il est à noter qu’une telle “Nuxeo Marketplace” existe déjà depuis fin
2010, avec pour l’instant des fonctions beaucoup plus limitées, et n’est
notamment pas intégrée à l’offre cloud de Nuxeo.

### Objectifs

-   TODO

### Principales tâches

-   Permettre l’intégration de l’outil de développement Nuxeo Studio
    avec le cloud (marketplace et déploiement).
-   Intégrer le modèle de partage de revenu dans le système de
    comptabilité et de facturation.

## Nuxeo Document Storage as a Service

### Contexte

Les plateformes de PaaS actuelles dont s’inspire Compatible One (ex:
Amazon S3 ou Google Storage) se focalisent sur le stockage de BLOBs ou
de fichiers. Il ne proposent pas les services que l’on attend d’un
système de gestion documentaire et qui ont été, pour partie, formalisés
dans le modèle documentaire du standard CMIS: gestion des gestion des
droits hiérarchique, indexation multi-critères, gestion du cycle de vie
des documents, check-in check-our, versionning, locking, etc.

Il s’agit donc ici de prosposer ces services sous la forme d’une API du
PaaS compatible (API Java exposée sous forme de services OSGi, ou API
web REST) afin de permettre à des développeurs de réaliser des
applications documentaires sans nécessairement adopter tous les
paradignes de la plateforme Nuxeo, notamment son interface utilisateur.

### Objectifs

-   Exposer via CMIS (+ d’éventuelles extensions) et des API Java les
    services fondamentaux de la GED, sous une forme consommable par des
    développeurs tiers, et facturer cette consommation à la demande
    selon le modèle Amazon ou Google.

-   Valider que ces API sont bien pertinentes et que le modèle a été
    découpé aux bons endroits.

### Challenges

-   Implémenter le service après découpage adéquat des composants
    serveurs Nuxeo.

-   Démontrer la pertinence des API par un ensemble de démonstrateurs

-   Valider la montée en charge par des benchmarks

### Principales tâches

-   Implémenter les API serveur.

-   Benchmark des performances.

-   Réalisation d’un démonstrateur d’application Web (mashup navigateur)
    basé sur l’API CMIS browser binding exposée par le démonstrateur.

-   Réalisation d’un démonstrateur d’application de synchronisation
    desktop pour Windows, Linux et Mac OS, exploitant les API REST côté
    serveur.

-   Réalisation d’un démonstrateur d’application mobile orientée contenu
    pour iPhone / iPad, Android et HTML5, exploitant les API REST côté
    serveur.


