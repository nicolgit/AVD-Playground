
# Playground design

This diagram shows a typical <a href="https://docs.microsoft.com/en-us/azure/architecture/example-scenario/wvd/windows-virtual-desktop" target="_blank">architectural setup</a> for Azure Virtual Desktop

![Azure Virtual Desktop reference architecture](images/azure-virtual-desktop.png)

* The application endpoints are in the customer's on-premises network. 
* ExpressRoute extends the on-premises network into the Azure cloud, and Azure AD Connect integrates the customer's Active Directory Domain Services (AD DS) with Azure Active Directory (Azure AD).
* The Azure Virtual Desktop control plane handles Web Access, Gateway, Broker, Diagnostics, and extensibility components like REST APIs.
* The customer manages AD DS and Azure AD, Azure subscriptions, virtual networks, Azure Files or Azure NetApp Files, and the Windows Virtual Desktop host pools and workspaces.
* To increase capacity, in this schema, the customer uses two Azure subscriptions in a hub-spoke architecture, and connects them via virtual network peering.

The diagram below shows the AVD playground we will create:

![Lab Architecture](images/lab-architecture.png)

* a V-Net with 2 subnets
    * subnetAD: in this subnet will be deployed an istance of Azure Active Directory Domain  Services. This full managed Active Domain will simplify the setup because  with few clicks you will have 2 Active Directory servers fully managed with an Azure AD Connect in place, an ideal configuration for WVD
    * subnetClients: in this subnet will be deployed all hosts (VM) used by WVD
* 2 Host pools (MilanoPool and RomaPool)
* MilanoPool has
    * 2 hosts (Milanovm-1 and Milanovm-2)
    * 1 Application group (MilanoDAG) with desktop access
* Romapool has
    * 1 host (romavm-1)
    * 1 Application group (RomaDAM) with desktop access
    * 1 Application group (RomaApplications) with 3 apps 

![Lab Configuration](images/lab-configuration.png)

Users will have the following access:

| User   | Application Groups                   |
|--------|--------------------------------------|
| User01 | RomaPoolDAG, MilanoPoolDAG, RomaApplications |
| User02 | RomaApplications                     |
| User03 | RomaApplications                     |



# Prerequisites

in order to create this lab you need:

* an Azure subscription (also Visual Studio subscribers benefit is ok)
* an Azure Active Directory Tenant where you are able to create users, groups etc.

> from cloud shell execute [00-variables.sh](shell-script/00-variables.sh) and [01-resource-group.sh](shell-script/01-resource-group.sh)

# Virtual Network

Create a virtual network with the following characteristics:
* Name: avd-network
* Address space: 10.10.0.0/16
* Subnets (name - range)
    * subnetAD - 10.10.1.0/24
    * subnetClients - 10.10.2.0/24

> from Azure cloud shell execute script `02-vnet.sh`

# Azure Active Directory preparation

If you plan to create and destroy the lab, using the same Azure Active Directory, **it is important to delete and re-create these account each time you rebuild the environemnt**.

| User UPN                                  | password       | role
|-------------------------------------------|----------------|-------------------------
| user01@\<yourtenantname\>.onmicrosoft.com | pa.123.assword |Active Directory administrator
| user02@\<yourtenantname\>.onmicrosoft.com | pa.123.assword |standard user
| user03@\<yourtenantname\>.onmicrosoft.com | pa.123.assword |standard user

Create a group named `AAD DC Administrators` and add `User01` as member.

> from azure cloud shell execute script `05-users` 

# Azure AD Domain Services

Create an Azure AD Domain Services with the following parameters:

Basic
* DNS domain name: demo.nicold
* Region: any
* SKU: standard
* Forest type: user

Network
* Virtual Network: avd-network
* Subnet: subnetAD
* NSG: xxxxxxxxxxxxxxxxx

Administration
* Notifications
    * All Global Administrators of the Azure AD directory.
    * Members of the AAD DC Administrators group.

Synchronicazion
* Synchronization type: All

Security Settings
* keep all default settings

when the deploy finish:
* the activity coud require more than 1 hour for the fisr sync
* Fix the DNS following the recomendation shown on overview page
* access with user01 and user02 on portal.azure.com and change the password so that the password is replicated also back in AD

# Assign User01 as ADDS Administrator

| Groups                                    | members 
|-------------------------------------------|-----------------------------------
| AAD DC Administrators                     | user01@<yourtenantname\>.onmicrosoft.com


# Create Host Pool 1 (Roma)

use the following parameter to create the RomaPool

Basic

* Host pool name: RomaPool
* Validating environment: No
* Host pool type: Pooled
* Load Balancing algorithm: Bread-first
* Max Session limit: 2

Virtual Machines

* Add Virtual Machines: Yes
* Resource Group: defaulted as host pool
* Name Prefix RomeVm
* Availability options: No infrastructure redundancy required
* Image Type: Gallery
* Image: Windows 10 Ent Multisession
* VM Size: D2s v3
* Number of VM: 1
* OS disk type: Standard HDD
* Boot Diagnostic: disabled
* Specify domain or unit: Yes
* Domain to Join: demo.nicold
* Virtual Network: avd-network
* subnet: subnetClients
* Network Security Group: none
* AD domain join UPN: user01@demo.nicold
* password: \*********
* Virtual Machine Admin account: myAdminAccount
* password: \*********

WorkSpace

* Register desktop app group: Yes
* Workspace Name: RomaWorkspace

when the host pool is ready, add user1 to RomaPoolDAG Application group


# Create Host Pool 2 (Milano)

use the following parameter to create the RomaPool

Basic

* Host pool name: MilanoPool
* Validating environment: No
* Host pool type: Pooled
* Load Balancing algorithm: Bread-first
* Max Session limit: 2

Virtual Machines

* Add Virtual Machines: Yes
* Resource Group: defaulted as host pool
* Name Prefix MilanVm
* Availability options: No infrastructure redundancy required
* Image Type: Gallery
* Image: Windows 10 Ent Multisession
* VM Size: D2s v3
* Number of VM: 2
* OS disk type: Standard HDD
* Boot Diagnostic: disabled
* Specify domain or unit: Yes
* Domain to Join: demo.nicold
* Virtual Network: avd-network
* subnet: subnetClients
* Network Security Group: none
* AD domain join UPN: user01@demo.nicold
* password: \*********
* Virtual Machine Admin account: myAdminAccount
* password: \*********

WorkSpace

* Register desktop app group: Yes
* Workspace Name: MilanoWorkspace

when the host pool is ready, add user1 to MilanoPoolDAG Application group

# Create an Additional Application group
From Windows Virtual Desktop -> Application groups -> Create

Basics

* HostPool: `RomaPool`
* Application Group Type: `Remote App`
* Application Group Name: `RomaApplications`

Applications
* Start menu -> Character Map
* Start menu -> Paint
* Start menu -> Wordpad

Assignments
* User01
* User02
* User03

Workspace
* Register application group: YES
* Register application group: RomaWorkspace


# Associate User01 to Desktop Rome and Milan
From Windows Virtual Desktop -> Application groups 

* Application Group: `MilanoPool-DAG` > Assignments: `user01`
* Application Group: `RomaPool-DAG` > Assignments: `user01`

******************************************************************************************
