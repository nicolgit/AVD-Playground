#!/bin/bash

source 00-variables.sh

az desktopvirtualization hostpool create \
  --host-pool-type Pooled \
  --load-balancer-type DepthFirst \
  --location $LOCATION \
  --name $ROMAPOOLNAME \
  --personal-desktop-assignment-type Automatic \
  --resource-group $RESOURCEGROUP \
                                         [--custom-rdp-property]

                                         [--friendly-name]
  --max-session-limit 10
                                         [--registration-info]
                                         [--ring]
                                         [--sso-context]
                                         [--tags]
                                         [--validation-environment {false, true}]
                                         [--vm-template]