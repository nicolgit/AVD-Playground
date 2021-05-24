This Lab demonstrates how to create a fully functional Windows Virtual Desktop (WVD) on Azure, without an Active Directory on premise. Objective of this lab is to have a procedure easy and repeatable, so that in a very small ammout of time is possible to create an entire environment ad destroy it with no fear once finished. 

# Playground design

This diagram shows a typical <a href="https://docs.microsoft.com/en-us/azure/architecture/example-scenario/wvd/windows-virtual-desktop" target="_blank">architectural setup</a> for Windows Virtual Desktop

![Windows Virtual Desktop reference architecture](images/windows-virtual-desktop.png)

* The application endpoints are in the customer's on-premises network. ExpressRoute extends the on-premises network into the Azure cloud, and Azure AD Connect integrates the customer's
* Active Directory Domain Services (AD DS) with Azure Active Directory (Azure AD).
The Windows Virtual Desktop control plane handles Web Access, Gateway, Broker, Diagnostics, and extensibility components like REST APIs.
* The customer manages AD DS and Azure AD, Azure subscriptions, virtual networks, Azure Files or Azure NetApp Files, and the Windows Virtual Desktop host pools and workspaces.
* To increase capacity, the customer uses two Azure subscriptions in a hub-spoke architecture, and connects them via virtual network peering.

This diagram shows the WVD playground we will create

![Lab Architecture](images/lab-architecture.png)

* a V-Net with 2 subnet
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



# Prerequisites

in order to create this lab you need:

* an Azure subscription (also Visual Studio subscribers benefit is ok)
* an Azure Active Directory Tenant where you are able to create users, groups etc.

# Azure Active Directory preparation

I suggest to do this step just once, and keep accounts and group creted also when the lab will be destroyed. This because there is no cost associated.

| User UPN                                  | password       | role
|-------------------------------------------|----------------|-------------------------
| user01@\<yourtenantname\>.onmicrosoft.com | pa.123.assword |Active Directory administrator
| user02@\<yourtenantname\>.onmicrosoft.com | pa.123.assword |standard user
| user03@\<yourtenantname\>.onmicrosoft.com | pa.123.assword |standard user

| Groups                                    | members 
|-------------------------------------------|-----------------------------------
| AAD DC Administrators                     | user01@\<yourtenantname\>.onmicrosoft.com

# Virtual Network

Create a virtual network with the following characteristics:
* Name: wvd-network
* Address space: 10.10.0.0/16
* Subnets (name - range)
    * subnetAD - 10.10.1.0/24
    * subnetClients - 10.10.2.0/24
   
# Azure AD Domain Services

Create an Azure AD Domain Services with the following parameters:

Basic
* DNS domain name: \<yourtenantname\>.onmicrosoft.com
* Region: any
* SKU: standard
* Forest type: user

Network
* Virtual Network: wvd-network
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






******************************************************************************************
