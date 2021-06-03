#!/bin/bash

LOCATION="westeurope"

DOMAIN="demo.nicold"
AADDOMAIN="nicoladelfinooutlook.onmicrosoft.com"
LOCATIONADDS="westeurope"

SUBSCRIPTIONID="efd828ab-4b87-4350-9f07-26ffc419ccdb"
RESOURCEGROUP="WVD-Playground"

VNET="wvd-playground-network"
VNETPREFIX="10.10.0.0/16"
SUBNETAD="subnetAD"
SUBNETADPREFIX="10.10.1.0/24"
SUBNETCLIENTS="subnetClients"
SUBNETCLIENTSPREFIX="10.10.2.0/24"

USER1="User01"
USER2="User02"
USER3="User03"
USER1UPN="$USER1@$AADDOMAIN"
USER2UPN="$USER2@$AADDOMAIN"
USER3UPN="$USER3@$AADDOMAIN"

PASSWORD="pa.123.assword"

ROMAPOOLNAME="RomaPool"
ROMAWORKSPACE="RomaWorkspace"

MILANOPOOLNAME="MilanoPool"
MILANOWORKSPACE="MilanoWorkspace"

VMTEMPLATEROMA= "{\"domain\":\"demo.nicold\",\"galleryImageOffer\":\"Windows-10\",\"galleryImagePublisher\":\"MicrosoftWindowsDesktop\",\"galleryImageSKU\":\"19h2-evd\",\"imageType\":\"Gallery\",\"imageUri\":null,\"customImageId\":null,\"namePrefix\":\"FirenzeVM\",\"osDiskType\":\"Standard_LRS\",\"useManagedDisks\":true,\"vmSize\":{\"id\":\"Standard_D2s_v3\",\"cores\":2,\"ram\":8},\"galleryItemId\":\"Microsoftwindowsdesktop.windows-1019h2-evd\"}"

