#!/bin/bash

az ad user create \
  --display-name $USER1 \
  --password $PASSWORD \
  --user-principal-name $USER1UPN \
  --force-change-password-next-sign-in false \
  -o json

az ad user create \
  --display-name $USER2 \
  --password $PASSWORD \
  --user-principal-name $USER2UPN \
  --force-change-password-next-sign-in false 

az ad user create \
  --display-name $USER3 \
  --password $PASSWORD \
  --user-principal-name $USER3UPN \
  --force-change-password-next-sign-in false 

USER1_ID=$(az ad user show --id $USER1 | jq -r .id)
az ad group member add --group "AAD DC Administrators"  --member-id $USER1_ID