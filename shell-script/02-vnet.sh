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

