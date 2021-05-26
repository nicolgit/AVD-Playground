#!/bin/bash

source 00-variables.sh

az ad ds create \
  --domain $DOMAIN \
  --name $DOMAIN \
  --resource-group $RESOURCEGROUP \
  --resource-forest "Disabled" \
  --sku "Standard" \
  --replica-sets location="$LOCATIONADDS" subnet-id="/subscriptions/efd828ab-4b87-4350-9f07-26ffc419ccdb/resourceGroups/WVD-Playground/providers/Microsoft.Network/virtualNetworks/wvd-playground-network/subnets/subnetAD"

# VERIFY WHAT MISSING AT THE END (I.E. dns ON VNET, ADMINISTRATOR IN IN GROUP ETC.)

#az network vnet subnet list \
#  --resource-group $RESOURCEGROUP \
#  --vnet-name $VNET