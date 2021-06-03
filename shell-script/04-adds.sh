#!/bin/bash

source 00-variables.sh

az ad ds create \
  --domain $DOMAIN \
  --name $DOMAIN \
  --resource-group $RESOURCEGROUP \
  --resource-forest "Disabled" \
  --sku "Standard" \
  --replica-sets location="$LOCATIONADDS" subnet-id="/subscriptions/$SUBSCRIPTIONID/resourceGroups/$RESOURCEGROUP/providers/Microsoft.Network/virtualNetworks/$VNET/subnets/$SUBNETAD"

# VERIFY WHAT MISSING AT THE END (I.E. dns ON VNET, ADMINISTRATOR IN IN GROUP ETC.)


az network vnet update \
  --name $VNET \
  --resource-group $RESOURCEGROUP \
  --dns-servers 10.10.1.5 10.10.1.4