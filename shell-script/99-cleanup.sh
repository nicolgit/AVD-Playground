#!/bin/bash

az ad user delete --id $USER1UPN
az ad user delete --id $USER2UPN
az ad user delete --id $USER3UPN

az ad group delete --group $GROUPDISPLAYNAME

az group delete --name $RESOURCEGROUP --no-wait
