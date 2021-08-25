#!/bin/bash

source 00-variables.sh

#Create Azure AD DS 
az ad ds create \
  --domain $DOMAIN \
  --name $DOMAIN \
  --resource-group $RESOURCEGROUP \
  --resource-forest "Disabled" \
  --sku "Standard" \
  --replica-sets location="$LOCATIONADDS" subnet-id="/subscriptions/$SUBSCRIPTIONID/resourceGroups/$RESOURCEGROUP/providers/Microsoft.Network/virtualNetworks/$VNET/subnets/$SUBNETAD"


#fix default DNS 
az network vnet update \
  --name $VNET \
  --resource-group $RESOURCEGROUP \
  --dns-servers 10.10.1.5 10.10.1.4