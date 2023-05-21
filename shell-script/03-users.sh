#!/bin/bash

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
