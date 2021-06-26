#!/bin/bash

source 00-variables.sh

exp_DATE=$(date -d "+10 days")
exp_DATE_STRING=$(date -d "$exp_DATE" -Ins)

az desktopvirtualization hostpool create \
  --resource-group $RESOURCEGROUP \
  --name FirenzePool \
  --host-pool-type Pooled \
  --load-balancer-type DepthFirst \
  --location $LOCATION \
  --personal-desktop-assignment-type Automatic \
  --registration-info expiration-time="$exp_DATE_STRING" registration-token-operation="Update" \
  --debug


FLOVM=FlorenceVM



az vm create \
  --name $FLOVM \
  --resource-group $RESOURCEGROUP \
  --image MicrosoftWindowsDesktop:Windows-10:20h1-pro:latest \
  --vnet-name $VNET \
  --subnet $SUBNETCLIENTS \
  --admin-password password.123 \
  --admin-username nicola \
  --public-ip-address "" \
  --size Standard_D2s_v3

az vm auto-shutdown \
  --resource-group $RESOURCEGROUP \
  --name $FLOVM \
  --time 2030 \
  --email "nicold@microsoft.com" \
  --webhook "https://www.pippo.com"




# join VM to Domain
az deployment group create \
  --resource-group $RESOURCEGROUP \
  --template-uri https://raw.githubusercontent.com/nicolgit/WVD-Playground/main/shell-script/ARM/joinAD.json \
  --parameters  location=$LOCATION vmList=$FLOVM,client02 domainJoinUserName=$DOMAIN\\$USER1 domainJoinUserPassword=$PASSWORD domainFQDN=$DOMAIN \
  --debug

# esempio di parametri 
#    --parameters "{ \"location\": { \"value\": \"westus\" } }" \
#--parameters "{ \"location\": { \"value\": \"$LOCATION\" }, \"vmList\": { \"value\": \"$FLOVM,client02\" }, \"domainJoinUserName\": { \"value\": \"$DOMAIN\\$USER1\" }, \"domainJoinUserPassword\": { \"value\": \"$PASSWORD\" }, \"domainFQDN\": { \"value\": \"$DOMAIN\" } }" \


{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "location": {
            "value": "southcentralus"
        },
        "vmList": {
            "value": "client01,client02"
        },
        "domainJoinUserName": {
            "value": "contoso\\username"
        },
        "domainJoinUserPassword": {
            "value": "GEN-PASSWORD"
        },
        "domainFQDN": {
            "value": "contoso.com"
        }
    }
}








add machine to domain
add machine to pool

https://docs.microsoft.com/en-us/azure/virtual-desktop/create-host-pools-powershell

https://github.com/Azure/RDS-Templates/tree/master/ARM-wvd-templates/CreateAndProvisionHostPool