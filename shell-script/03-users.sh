#!/bin/bash

source 00-variables.sh

USER1JSON=$(az ad user create \
  --display-name $USER1 \
  --password $PASSWORD \
  --user-principal-name $USER1UPN \
  --force-change-password-next-login false \
  -o json)

USER1ID=$(echo $USER1JSON | jq '.objectId' | sed 's/"//g')

az ad user create \
  --display-name $USER2 \
  --password $PASSWORD \
  --user-principal-name $USER2UPN \
  --force-change-password-next-login false 

az ad user create \
  --display-name $USER3 \
  --password $PASSWORD \
  --user-principal-name $USER3UPN \
  --force-change-password-next-login false 

az ad sp create-for-rbac --name "2565bd9d-da50-47d4-8b85-4c97f669dc36"

GROUPID=$(az ad group create \
  --display-name "AAD DC Administrators" \
  --description "Delegated group to administer Azure AD Domain Services" \
  --mail-nickname "AADDCAdministrators" \
  -o json \
  --query 'objectId' | sed 's/"//g')

az ad group member add \
  --group $GROUPID \
  --member-id $USER1ID
