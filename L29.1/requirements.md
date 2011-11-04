# Requirements

NB: pour des raisons historiques, cette partie a été écrite en anglais.

## High level requirements

### Integrated Configuration and test environment in the Cloud

Nuxeo Connect users can already use the configuration services provided by Nuxeo Studio to configure their local Nuxeo instance.

In the future, we want to leverage the Cloud infrastructure to let the user directly test his customization on a Cloud instance.

This basically means:

 - create the target VM

 - deploy the target Nuxeo distribution 

 - deploy the Studio configuration

Since we are currently integrating Studio and Eclipse IDE, the next step will be to provide the same Cloud services so that developers working on Nuxeo Platform can use the Could infrastructure to provision test instances and test their custom applications.

### One click production environment

For clients using the Cloud infrastructure to customize and develop their Nuxeo based application, the obvious next step is to be able to run the production instances directly on the Cloud too.

### Scaling out

Nuxeo also wants to leverage the Could infrastructure to provide an easy scaling solution.

This includes:

 - using Cloud based filesystem for document storage

 - using Cloud ready Database systems for meta-data storage

 - provide true multi-tenant support

 - deploy Nuxeo components on multiple VMs (Spanning or clustering)

### ECM as a service

Nuxeo ECM platform provides several technology neutral API to access and manage content:

 - CMIS connector: standard compliant interoperability protocols 

 - Content Automation: Extensible and Business friendly REST API

One of the goals of Nuxeo's Cloud approach is to be able to provide ECM features as a service via CMIS and Content Automation.

## Technical requirements

### Nuxeo component deployment and OSGi

Nuxeo platform component model being based on an OSGi, we want to be able to deploy the required bundles according to a global configuration.

#### OSGi-based distribution 

Currently Nuxeo distributions are a selection of Maven Artifacts (Code or Configuration resources) that is generated using a dedicated maven plugin.

The selection of the required artifact is based on maven dependencies and the assembly is done at packaging time.

Our goal is to be able to have distributions based on OSGi rather than maven.

This means having a descriptor listing the required bundles and letting the OSGi deployment and provisionning system pull and activate the needed bundles dynamically.

This kind of features is for example available using some forked versions of P2 director with Equinox.

At the end this high level descriptor should be enough to create a specific instance of Nuxeo on the Cloud:

 - the descriptor contains the list of needed features

 - the OSGi dependency and provisioning system know how to find the bundles

 - the PAAS knows how to deploy and run a set of OSGi bundles as an application

 - OSGi know how to assemble (fragments), start and activate the bundles 

We need to define a standard descriptor model for this as well has the tools and infrastructure to run it.

For illustration purpose, the target command line could look something like:

    > compatible --deploy <software-descriptor-url> <instance-descriptor-url>

where:

- `software-descriptor-url`: is an url pointing to a file listing the top level required bundles
- `instance-descriptor-url`: is an url pointing to a file containing VM deployment configuration

The expected gains for this switch from maven to an OSGi distribution model are:

- better integration with the low level provisioning systems

- be able to dynamically add new features by adding new bundles (no restart, just additional activation)

- be able to dynamically add or refresh configuration bundles


These features are very important for running a useful ECM platform on the Cloud:

- we want to be able to easily refresh configuration
  \newline
  $\Rightarrow$ let end users change some configuration in Nuxeo Studio and directly see the result in his production system

- we want to let able to add or remove services on a running application instance
  \newline
  $\Rightarrow$ let the end user subscribe to additional services and features
   (without recreating a new instance or restarting the existing one)

#### Stay compatible

Even is we build a very cool Cloud platform, we will still need to stay as much as possible compatible with other deployment infrastructure.

And, at least, we must provide bridges so that applications that run inside the Cloud, can also be run on premises.

So, even if we must leverage the Cloud infrastructure, we should still be able to run part of the software services on standard internal IT infrastructure.

It provides a smooth migration to the cloud model and allows for a mixed model:

- use Cloud for evaluation or development environment, but deploy on premises for security reasons

- Manage dev and testing in-house but use the Cloud for production hosting

- Start with in-house deployment and scales out to the Cloud when needed

This basically means that there should be a strong decoupling between the application layer and the cloud infrastructure and deployment model.

For that matter, OGSi model provides part of the solution since it standardize several aspects of the application life-cycle.

For on premises deployments we need to be able:

- to propose alternative for the Cloud based features (like standard DB/FS storage)

- to run as a standard JEE application

This second point may seem like a problem, but:

- this problem can be not addressed

- this should not be a big constraint

In fact several application servers have OSGi support, and Nuxeo EP currently deploys OSGi and Nuxeo Components in JBoss 5 and Tomcat 6.

The difficulty will be to disturb as less as possible the people deploying on premises application:

$\Rightarrow$ this must be as simple and copying a WAR or an EAR

$\Rightarrow$ it does not means we need to deploy a real WAR or EAR
   (we can rely on deployment hooks and embedded OSGi runtime)

### Multi-tenancy

We have use cases for using Nuxeo DM as a multi-tenant aware platform.

The typical requirements are:

- be able to have per-tenant data 
  \newline
  $\Rightarrow$ Users from company A can not access the documents from company B.
  \newline
  $\Rightarrow$ Company B can ask for a data restore without impacting company A

- be able to have per-tenant configuration
  \newline
  $\Rightarrow$ The InvoiceA document Type is only available for people from company A.

- be able to have per-tenant feature list (available services)
  \newline
  $\Rightarrow$ CompanyA has access to a Signature service, but not CompanyB

- be able to do hot-reconfiguration/redeployment on a per-tenant basis
  \newline
  $\Rightarrow$ CompanyA can do an upgrade without impacting CompanyB

#### Doing Multi-tenant in the Could

Traditional approaches for managing multi-tenant is to change the application so you have business rules to tell the software how to use shared the hardware resources between clients.

This approach has several drawbacks in our case:

- Making multi-tenant aware all software component is hard job

  - possibly a lot of work

  - must be addressed for each new feature

- Since application level rules may change, the admin work (ex: backup and restore) can become a nightmare

A brute force approach would be to say that since of the Cloud the resources are virtually unlimited, we can simply clone a new instance for each client.

But, we can probably do better than that to leverage as much as possible the overhead of adding a 'logical' (client) instance to a running instance.

#### OSGi and multi-tenant

If we include the Multi-tenant management system directly inside the OSGi deployment infrastructure, we should be able to avoid most of the application level complexity.

From a high level point of view, we want to be able to run several OSGi distributions at the same time while sharing the common bundles and configuration.

So for example, if user's Principal contains information about a Tenant:

- we should be able to make available some services or not

- we should be able to take into account one configuration bundle or an other

My understanding is that there are currently discussion somehow related to these problematics in the OSGi/P2/Virgo community.

#### Infrastructure requirements 

Low level infrastructure is also impacted by the multi-tenant use case:

- impact on backup/restore systems

- impact on admin and deployment tools

#### Nuxeo level requirements 

Even if we have a fully multi-tenant aware infrastructure, there will still be impacts at Nuxeo level.

- OSGi alignments for services

- Improve extension points registries (or align to Equinox system)

- Improve fragment system (or align on OSGi partial standard)

### VM provisioning

In order to automate instance creation, we need a vendor neutral API to provision cloud instances that will be used to deploy Nuxeo instances.

Ideally, we want it to be integrated with the OSGi distribution system so that we can deploy in one command: Software distribution and Runtime environment.

### Distributed storage

Today the Nuxeo content repository uses a simple file system to store the binary files, however files are stored in an intelligent manner in order to minimize duplication and avoid locking and reference counting.

In the future we want to leverage distributed storage services like S3. This will allow storage of binary files (which are the biggest consumers of the storage space used by a document management system) in a totally scalable manner, with the intrinsic redundancy offered by such cloud-based systems.

This will be a new plugin for the Nuxeo Binary Manager:

- using a local filesystem cache (for performance reasons),

- using as much as possible a neutral distributed file system API (as provided for instance by the jclouds BlobStore project).

### NoSQL storage

Even if we have no immediate requirement for it, we want to explore the possibility of using a NoSQL-based storage for our content repository.

The target is to be able to have a theoretically infinite-scale storage for the Nuxeo repository metadata.

This task is significantly more complex that simply addressing binaries storage since we need to be able to:

- manage transactions,

- manage locking,

- have an efficient query system, with dynamically created queries in
some use cases,

- provide full-text indexing.

To be fair, this does not need to be a real NoSQL storage. Having a large scale RDBMS clustering and sharding system, would be good as well.

### Distributed Caching

Nuxeo supports clustering at repository level.

The clustering model requires a cache system that can be synched between the Cluster nodes.

This is currently done:

- using separated in memory "session caches":

  - there is no intra-VM shared cache

  - there is no multi-VM shared cache

- multi-VM sync go through the database

We plan to work on this subject to provide a truly distributed caching system that will can use in Cluster mode on the Cloud.

This improvement will probably be needed if we want to scale out efficiently on multiple Cloud nodes.

