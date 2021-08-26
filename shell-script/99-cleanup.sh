#!/bin/bash

source 00-variables.sh

az ad user delete --id $USER1UPN
az ad user delete --id $USER2UPN
az ad user delete --id $USER3UPN

az ad group delete --group $GROUPDISPLAYNAME

az group delete $RESOURCEGROUP --no-wait
