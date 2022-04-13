in order to work, this solution requires the following infrastructure on Azure:

* a Resource Group
* a Storage Account
* a Static Web App

we will deploy everything via Az CLI

# Az Command Lin3 Interface (CLI)

The Azure command-line interface (Azure CLI) is a set of commands used to create and manage Azure resources. The Azure CLI is available across Azure services and is designed to get you working quickly with Azure, with an emphasis on automation.
* https://docs.microsoft.com/en-us/cli/azure/

# Common variables

```bash
LOCATION="westeurope"
RESOURCEGROUP="parco-leonardo-pm-sample"
STORAGEACCOUNT="plpmstoragesample"
STATICAPP="parco-leonardo-pm-app-sample"

CUSTOMDOMAIN="parcoleonardo.azurezone.caledos.com"

GITSOURCE="https://github.com/nicolgit/core-sensor-reader-forked" 
```


# Create a Resource Group
A resource group is a container that holds related resources for an Azure solution. The resource group can include all the resources for the solution, or only those resources that you want to manage as a group. You decide how you want to allocate resources to resource groups based on what makes the most sense for your organization. Generally, add resources that share the same lifecycle to the same resource group so you can easily deploy, update, and delete them as a group
* https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/manage-resource-groups-portal

```bash
az group create \
    --name $RESOURCEGROUP \
    --location $LOCATION
```

# Create storage account
An Azure storage account contains all of your Azure Storage data objects: blobs, file shares, queues, tables, and disks. The storage account provides a unique namespace for your Azure Storage data that's accessible from anywhere in the world over HTTP or HTTPS. Data in your storage account is durable and highly available, secure, and massively scalable.
* https://docs.microsoft.com/en-us/azure/storage/common/storage-account-overview

```bash
az storage account create \
  --name $STORAGEACCOUNT \
  --resource-group $RESOURCEGROUP \
  --location $LOCATION \
  --sku Standard_LRS \
  --kind StorageV2
```

# Create Azure Static Web App
Azure Static Web Apps is a service that automatically builds and deploys full stack web apps to Azure from a code repository.
* https://docs.microsoft.com/en-us/azure/static-web-apps/overview

First fork the repo https://github.com/nicolgit/core-sensor-reader/ then run the following (remember to have in $GITSOURCE the forked repository name)

```bash
az staticwebapp create --branch master \
                       --location $LOCATION \
                       --name $STATICAPP \
                       --resource-group $RESOURCEGROUP \
                       --source $GITSOURCE \
                       --app-location front-end \
                       --login-with-github \
                       --output-location www \
                       --sku Free \
```

the cli will request to grant 
