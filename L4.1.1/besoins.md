# Expression des besoins 

Cette section décrit les principaux enjeux de la cloudification d'une plateforme d'ECM comme Nuxeo et de son écosystème d'applications métiers, horizontales et verticales.

Les trois objectifs primaires fixés initialement pour les démonstrateurs du SP4.1 sont:
  
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

Dans un contexte cloud, l’ensemble de ces serveurs et outils sont en général packagés dans un ou des
VM, afin de garantir une bonne isolation entre les applications des
différents utilisateurs.

Ce mode de déploiement présente cependant plusieurs défis:

-   *scaling down*: la taille minimale d’une VM contenant une instance
    de Nuxeo, pour avoir des performances décentes pour une utilisation
    non intensive par quelques dizaines d’utilisateurs est de 2 Go.
    Proposer des applications pour les très petits utilisateurs (TPE) ou
    des versions d’essais n’est économiquement rentable que si on passe
    par une approche où plusieurs clients sont hébergés dans la même VM,
    et même dans la même JVM (i.e. le même serveur d’appli), ce qui
    oblige à passer par une approche multi-tenants.

-   *scaling up*: un utilisateur ayant des gros besoins devra utiliser
    des VM plus importantes (\> 10 Go de RAM, CPU multi-cores
    puissants), jusqu’à un point où seule une installation
    multi-serveurs est capable de répondre aux besoins. Dans ce cas,
    plusieurs VM doivent être provisionnées, selon plusieurs templates
    (base de données, repository, transformation, frontaux), en fonction
    du besoin du client. Ce "capacity planning" manuel est consommateur
    de resources humaines, et ne permet pas une élasticité optimale des 
    solutions déployées: il doit être possible de faire mieux en utiliser
    des technologies cloud dédiées!

-   *tolérance aux pannes*: un déploiement mono-serveur est sensible aux
    pannes matérielles ou logicielles, il convient d’introduire de la
    redondance et des mécanismes de fail-over si on souhaite garantir
    aux utilisateurs les SLAs qu'ils attendent, et non du "best effort".

Plus généralement, les besoins d’un client peuvent évoluer et c’est une
des propositions de valeur du cloud computing de permettre aux
utilisateurs d’adapter le dimensionnement de leur application en
fonction de l’évolution de leurs besoins. L'objectif pour Nuxeo est de se
donner les moyens techniques de répondre à ces attentes, qui seront de
plus en plus pressantes à mesure que l'approche cloud computing va se
démocratiser.

### Objectifs

Disposer de prototypes de la plateforme et des applications Nuxeo sous une forme exploitant
une partie plus ou moins importante des fonctionnalités de Compatible
One (IaaS seul, IaaS + PaaS, PaaS seul), de façon à les benchmarker et
pouvoir évaluer la pertinence d’en dériver ultérieurement des produits
industrialisés.

### Challenges

-   Démontrer la pertinence des outils du SP1 (IaaS) pour le
    provisionning et la gestion de machines virtuelle, de stockage virtualisés,
    et le déploiement automatisé d'applications.

-   Démontrer la pertinence des services la plateforme SP2 (PaaS), en
    particulier:
    -   Le runtime OSGi.
    -   Le stockage (des métadonnées et des BLOBs).
    -   Le service de gestion documentaire qui sera lui-même une
        abstraction des services Nuxeo bas niveau (Nuxeo Core).
    -   Le monitoring et les services liés à l'auto-scalabilité.

-   Aussi bien au niveau du IaaS que du PaaS, un challenge important est la gestion de l'élasticité du cloud sous-jacent, gestion que l'on souhaite rendue autant que possible transverse aux points d'attention des développeurs d'applications.
        
### Principales tâches

Nous listons ci-après les principales tâches que nous pensons nécessaire d'accomplir pour démontrer la pertinence du cloud Compatible One dans le cadre ainsi fixé:

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
    
### Roadmap

Afin de procéder de manière itérative et de maximiser les opportunités de collaboration avec les autres SP, notamment SP1 et SP2, le plan est de réaliser la tâche SP4.1 par étapes, en commençant par les modifications les moins intrusives pour les logiciels Nuxeo existants, et les plus en phase avec l'état de l'art actuel du cloud computing (e.g. Amazon AWS).

#### Phase 1: Nuxeo sur le IaaS Compatible One

Dans cette phase, les logiciels Nuxeo sont déployés dans des VM grâce aux API et aux services du SP1.

\begin{figure}[h!]
\centering
\includegraphics[width=10cm]{images/nuxeo-on-iaas.png}
\caption{Nuxeo sur le IaaS}
\end{figure}

Par extension, il est aussi possible que l'on expérimente l'utilisation des services du PaaS (par exemple, le stockage des blobs et le stockage relationnel) sans remettre en cause cependant le modèle de déploiement. 

Il s'agit d'une phase relativement peu risquée, car les services IaaS se présentent à l'heure actuelle sous une forme relativement stabilisée (e.g. Amazon EC2), il sera donc possible de conduire des expérimentations sur le cloud Amazon (ou Rackspace, Gandi, etc.) sans avoir besoin de déployer un cloud Compatible One pour les tests.

#### Phase 2: Nuxeo sur le PaaS de Compatible One

Cette deuxième phase est plus intrusive pour la base de code Nuxeo, et représente également un challenge plus important pour la collaboration au sein du projet, du fait qu'elle suppose d'arriver à faire tourner les logiciels Nuxeo dans un "container" cloudifié, typiquement un environnement OSGi.

\begin{figure}[h!]
\centering
\includegraphics[width=10cm]{images/nuxeo-on-paas.png}
\caption{Nuxeo sur le PaaS}
\end{figure}

Cette phase sera également l'occasion d'approfondir l'utilisation des autres services PaaS, ainsi que des fonctionnalités d'auto-scalabilité du cloud Compatible One.

Une partie des expérimentations pourra se faire "en local", une partie nécessitera la mise à disposition d'une véritable instance du cloud Compatible One, notamment pour ce qui concerne l'auto-scalabilité.

### Use cases et contraintes pour les autres SP

Nous listons ci-après les prérequis sur les autres SP induits par le use case 4.1: 

-   SP1.2: TODO tiry.

-   SP1.3 et SP2.3: doivent fournir un système de stockage de binaires (BLOBs), élastique autant que possible, à défaut simple à provisionner et à rendre auto-scalable. Ce système peut être utilisé soit directement depuis les API systèmes de l'OS (i.e. en tant que filesystem), soit en tant que service (HTTP ou autre, de manière similaire à Amazon S3).

-   SP2.4: doit fournir un environnement d’exécution de services OSGi
    scalable, managé, etc. Il doit pouvoir être possible de:
    
    - déployer simplement des applications à partir d'un "bundle repository" et de descripteurs de ces applications.
    - définir, avec ces descripteurs ou mieux grâce à des règles métiers, les schémas de déploiement de ces services sur les noeuds de la plateforme OSGi (i.e. les instances de JVM), en fonction des règles de SLA.
    - redéployer ou migrer très rapidement (sans downtime) les applications d'une configuration à une autre.
    
    Ce service pourrait être comparable à ce que
    proposent Paremus Service Fabric (<http://www.paremus.com>) ou bien
    le PaaS d’Intalio (<http://www.intalio.com/osgi>).

-   SP2.6: doit fournir les services “core” de Nuxeo sous une forme
    totalement multitenant (isolation des repositories, des utilisateurs
    et des customisations) dans un même environnement d’exécution OSG
    (SP2.4). Plusieurs approches sont d'ailleurs possibles, dépendant du 
    niveau de "multitenancy" souhaité.

-   SP2.5: doit permettre la comptabilisation des ressources IaaS et
    PaaS consommées par les applications Nuxeo afin d'envisager de proposer 
    des schémas de facturation à la demande.

-   SP2.1: permettre l’exécution de jobs asynchrone de type MapReduce et
    GridGain, afin notamment de proposer des services de transformation de contenu:
    vignettage de videos, redimensionnement et conversion en batch de photos,
    rendu de documents de formats bureautiques ou autres vers PDF ou autres.

## Cloudification d’application verticales tierces

### Contexte

Un objectif stratégique pour Nuxeo est d'encourager le développement d’applications verticales (aussi appelées CEVAs pour "Content Enabled Vertical Applications" ou CCA pour "Composite Content Applications)
au-dessus de sa plateforme, par des développeurs tiers.

Afin de rendre cette approche attractive pour les développeurs, Nuxeo
souhaite proposer une approche intégrée, depuis le développement
jusqu’au déploiement des applications ("build to run"), en passant par la facturation et
le paiement par les utilisateurs, avec partage des revenus entre Nuxeo
et les développeurs tiers, similaire au modèle de l'App Store d'Apple.

Il est à noter qu’une telle “Nuxeo Marketplace” existe déjà depuis fin
2010, avec pour l’instant des fonctions beaucoup plus limitées, et n’est
notamment pas intégrée à l’offre cloud de Nuxeo.

\begin{figure}[h!]
\centering
\includegraphics[width=10cm]{images/nuxeo-cevas.png}
\caption{Nuxeo pour les CEVAs}
\end{figure}

### Objectifs

-   Proposer aux développeurs tiers (ISVs) un environnement de build, de test et de run qui leur permette de se concentrer sur leur offre métier.

-   Proposer un espace de promotion de ces applications, ainsi que la possibilité pour les clients de commander directement une application selon un mode de facturation qui peut être déterminé 

### Principales tâches

-   Permettre l’intégration de l’outil de développement Nuxeo Studio
    avec le cloud (marketplace et déploiement).
-   Intégrer le modèle de partage de revenu dans le système de
    comptabilité et de facturation.

## Nuxeo Document Storage as a Service

Cette partie du use case 4.1 correspond au SP 2.6 ("CMIS as a Service"), nous en reprenons ici seulement les grandes lignes en renvoyant au livrable 2.6.1 pour les détails des spécifications.

### Contexte

Les plateformes de PaaS actuelles dont s’inspire Compatible One (ex:
Amazon S3 ou Google Storage) se focalisent sur le stockage de BLOBs ou
de fichiers. Il ne proposent pas les services que l’on attend d’un
système de gestion documentaire et qui ont été, pour partie, formalisés
dans le modèle documentaire du standard CMIS: gestion des gestion des
droits hiérarchique, indexation multi-critères, gestion du cycle de vie
des documents, check-in check-out, versionning, locking, etc.

Il s’agit donc ici de proposer ces services sous la forme d’une API du
PaaS compatible (API Java exposée sous forme de services OSGi, ou API
web REST) afin de permettre à des développeurs de réaliser des
applications documentaires sans nécessairement adopter tous les
paradigmes de la plateforme Nuxeo, notamment son interface utilisateur.

\begin{figure}[ht]
\centering
\includegraphics[width=10cm]{images/nuxeo-as-paas.png}
\caption{Nuxeo comme service PaaS}
\end{figure}

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
