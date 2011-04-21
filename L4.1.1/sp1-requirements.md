# Requirements Nuxeo pour le SP1

> **Abstract:** Ce document présente l'utilisation actuelle des technologies Cloud par Nuxeo (sur la plateforme Amazon EC2), et les besoins identifiés pour améliorer ou optimiser cette utilisation.

## Utilisation du cloud par Nuxeo

### Besoins

Pour que les applications Nuxeo puissent fonctionner de manière satisfaisante, il nous faut au minimum une VM capable de faire tourner l'application elle-même (application java, de préférence sous Linux, avec ses dépendances externes), ainsi qu'une base de données, un stockage persistent, et une connectivité IP.

### Implémentation

Nuxeo utilise pour l'instant des instances EC2, basées sur des AMIs Ubuntu ou Debian relativement standard (celles d'Alestic).

Nous installons alors manuellement le package .deb Nuxeo en adaptant la configuration de façon à utiliser comme stockage un volume EBS (pour le stockage filesystem et pour la base de données PostgreSQL), avec un reverse-proxy Apache en frontal.

Une adresse IP fixe est allouée à chaque instance.

La plupart du temps, un deuxième volume EBS est utilisé pour les backups (on fait alors un snapshot de ce volume après chaque backup).

Optionnellement, le frontal HTTP et/ou la base de données peuvent être sur des instances séparées.

## Besoins pressentis pour une meilleure utilisation

### Faiblesses avérées de l'implémentation actuelle

Nous avons été confrontés à plusieurs faiblesses lors de l'implémentation. Certaines d'entre elles sont contournables, mais il serait mieux d'avoir ces fonctionnalités gerées directement par l'infrastructure de cloud.

- Impossibilité d'avoir plus d'une IP publique par VM (ce qui est notamment problématique pour la gestion de domaines multiples en HTTPS).

- Les machines virtuelles sont liées à un kernel et ramdisk qu'on ne peut pas modifier après la création de l'instance, ce qui limite fortement les possibilités de mises à jour.

- Pas de partage des EBS, donc pas de filesystem partagé pour des configurations cluster.

- Pas de garantie d'écriture sur le volume EBS avant un snapshot. Cela nous oblige à faire un unmount du volume de backup avant chaque snapshot.

- Pas de redimensionnement dynamique des instances (CPU, mémoire) bien que certains systèmes d'exploitation le supportent, ni de la taille des volumes EBS, la montée en capacité des applications ne peut donc se faire que de façon horizontale.

- Pas de gestion d'infrastructures multi-machines (jusqu'à AWS CloudFormation le 25/02/2011), les architectures multi-VMs ne pouvaient donc pas être gérées de façon intégrée.

- Au niveau administration et comptabilité, pas de possibilité de segmenter le compte AWS ni de déléguer certaines tâches administratives.

### Fonctionnalités supplémentaires utiles pour l'avenir

- Support d'architectures et protocoles réseau plus avancées (virtual switches, IPv6, IPSec...)

- Bases de données PostgreSQL "black box" (type RDS)

- Diverses autres fonctionnalités en "black box": reverse-proxy HTTP/HTTPS, relai SMTP vers un hôte ou une liste d'hôtes données (puisque n'importe quel cloud public va de toutes façons se retrouver dans les blacklists anti-spam), SMSC, AMQP...

- Conversion des VMs entre plusieurs architectures de virtualisation, pour pouvoir migrer simplement de l'une à l'autre, passer d'un fournisseur à un autre, ou d'un cloud privé à un cloud public (et inversement).
