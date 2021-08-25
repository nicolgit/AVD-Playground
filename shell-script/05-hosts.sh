#!/bin/bash

source 00-variables.sh



# https://github.com/Azure/RDS-Templates/tree/master/ARM-wvd-templates/CreateAndProvisionHostPool
PREFIX="Naples"

DEPLOYMENTNAME="${PREFIX}Deployment${RANDOM}"
POOLNAME="${PREFIX}Pool"
WORKSPACENAME="${PREFIX}Workspace"
EXPTIME=$(date -d "+5 days" -I)

az deployment group create \
  --name $DEPLOYMENTNAME \
  --resource-group $RESOURCEGROUP \
  --debug \
  --template-uri "https://raw.githubusercontent.com/Azure/RDS-Templates/master/ARM-wvd-templates/CreateAndProvisionHostPool/CreateHostpoolTemplate.json" \
  --parameters hostpoolName="$POOLNAME" hostpoolFriendlyName="$POOLNAME" location="$LOCATION" workSpaceName="$WORKSPACENAME" workspaceLocation="$LOCATION" workspaceResourceGroup="$RESOURCEGROUP" isNewWorkspace="true" addToWorkspace="true" administratorAccountUsername="{$USER1}@{$DOMAIN}" administratorAccountPassword="$PASSWORD" vmAdministratorAccountUsername="nicola" vmAdministratorAccountPassword="$PASSWORD" vmResourceGroup="$RESOURCEGROUP" vmLocation="$LOCATION" vmSize="Standard_D2s_v3" vmNumberOfInstances=2 vmNamePrefix="$PREFIX" vmImageType="Gallery" vmGalleryImageOffer="Windows-10" vmGalleryImagePublisher="MicrosoftWindowsDesktop" vmGalleryImageSKU="20h1-pro" vmDiskType="Standard_LRS" hostpoolType="Pooled" maxSessionLimit=10 loadBalancerType="BreadthFirst" preferredAppGroupType="Desktop" tokenExpirationTime="$EXPTIME" existingVnetName="$VNET" existingSubnetName="$SUBNETCLIENTS" virtualNetworkResourceGroupName="$RESOURCEGROUP" domain="$DOMAIN"
 
az vm auto-shutdown \
  --resource-group $RESOURCEGROUP \
  --name ${PREFIX}-0 \
  --time 2030 \
  --email "PIPPO@usa.net" \
  --webhook "https://www.pippo.com"

az vm auto-shutdown \
  --resource-group $RESOURCEGROUP \
  --name ${PREFIX}-1 \
  --time 2030 \
  --email "PIPPO@usa.net" \
  --webhook "https://www.pippo.com"



#
# helper to find a VM SKU to use
#
# az vm image list-publishers -l westeurope --output table
# az vm image list-offers -l westeurope -p MicrosoftWindowsDesktop --output table
# az vm image list-skus -l westeurope -f Windows-10 -p MicrosoftWindowsDesktop --output table
#
# pubilsher: MicrosoftWindowsDesktop
# offer: Windows-10
# sku: 20h1-pro



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


az vm auto-shutdown \
  --resource-group $RESOURCEGROUP \
  --name $FLOVM \
  --time 2030 \
  --email "nicold@microsoft.com" \
  --webhook "https://www.pippo.com"










add machine to domain
add machine to pool

https://docs.microsoft.com/en-us/azure/virtual-desktop/create-host-pools-powershell

https://github.com/Azure/RDS-Templates/tree/master/ARM-wvd-templates/CreateAndProvisionHostPool