#!/bin/bash

source 00-variables.sh

#Create vnet
az network vnet create \
  --name $VNET \
  --resource-group $RESOURCEGROUP \
  --location $LOCATION \
  --address-prefixes $VNETPREFIX \
  --subnet-name $SUBNETAD \
  --subnet-prefix $SUBNETADPREFIX

#Create client subnet
az network vnet subnet create \
  --resource-group $RESOURCEGROUP \
  --vnet-name $VNET \
  --name $SUBNETCLIENTS \
  --address-prefixes $SUBNETCLIENTSPREFIX

#Create NSG 
az network nsg create \
  --name aadds-nsg \
  --resource-group $RESOURCEGROUP
 
#Create NSG rule "AllowRD"
az network nsg rule create \
  --resource-group $RESOURCEGROUP \
  --name AllowRD \
  --nsg-name aadds-nsg \
  --access Allow \
  --protocol TCP \
  --direction Inbound \
  --priority 201 \
  --source-address-prefixes CorpNetSaw \
  --source-port-ranges "*" \
  --destination-address-prefixes "*" \
  --destination-port-ranges 3389
 
#Create NSG rule "Allow PS Remoting"
az network nsg rule create \
  --resource-group $RESOURCEGROUP \
  --name AllowPSRemoting \
  --nsg-name aadds-nsg \
  --access Allow \
  --protocol TCP \
  --direction Inbound \
  --priority 301 \
  --source-address-prefixes AzureActiveDirectoryDomainServices \
  --source-port-ranges "*" \
  --destination-address-prefixes "*" \
  --destination-port-ranges 5986
 
# Associate the NSG with the VNET subnet
az network vnet subnet update \
  --resource-group $RESOURCEGROUP \
  --name $SUBNETAD \
  --vnet-name $VNET \
  --network-security-group aadds-nsg
