#!/bin/bash

LOCATION="westeurope"

DOMAIN="demo.nicold"
AADDOMAIN="auth.duckiesfarm.com"

SUBSCRIPTIONID=$(az account show | jq '.id' | sed 's/"//g')

USER1="User01"
USER2="User02"
USER3="User03"
USER1UPN="$USER1@$AADDOMAIN"
USER2UPN="$USER2@$AADDOMAIN"
USER3UPN="$USER3@$AADDOMAIN"

GROUPDISPLAYNAME="AAD DC Administrators"
GROUPMAILNICKNAME="AADAdministrators"

PASSWORD="pa.123.assword"
