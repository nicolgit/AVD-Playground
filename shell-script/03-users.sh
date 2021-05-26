#!/bin/bash

source 00-variables.sh

az ad user create \
  --display-name $USER1 \
  --password $PASSWORD \
  --user-principal-name $USER1UPN \
  --force-change-password-next-login false 

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
