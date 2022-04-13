#!/bin/bash

LOCATION="westeurope"

DOMAIN="demo.nicold"
AADDOMAIN="nicoladelfinooutlook.onmicrosoft.com"
LOCATIONADDS="westeurope"

SUBSCRIPTIONID=$(az account show | jq '.id' | sed 's/"//g')

RESOURCEGROUP="avd-playground"

VNET="avd-playground-network"
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

GROUPDISPLAYNAME="AAD DC Administrators"
GROUPMAILNICKNAME="AADAdministrators"

PASSWORD="pa.123.assword"
