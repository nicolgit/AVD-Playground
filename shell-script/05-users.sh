#!/bin/bash

source 00-variables.sh

USER1JSON=$(az ad user create \
  --display-name $USER1 \
  --password $PASSWORD \
  --user-principal-name $USER1UPN \
  --force-change-password-next-sign-in false \
  -o json)

USER1ID=$(echo $USER1JSON | jq '.objectId' | sed 's/"//g')

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

GROUPID=$(az ad group create \
  --display-name $GROUPDISPLAYNAME \
  --description "Delegated group to administer Azure AD Domain Services" \
  --mail-nickname $GROUPDISPLAYNAME \
  -o json \
  --query 'objectId' | sed 's/"//g')

az ad group member add \
  --group $GROUPID \
  --member-id $USER1ID

# wait at least 1 hour and doublecheck that AD Connect have syncronized users before to go to the next step
