#!/bin/bash

source 00-variables.sh

az group create \
    --name $RESOURCEGROUP \
    --location $LOCATION