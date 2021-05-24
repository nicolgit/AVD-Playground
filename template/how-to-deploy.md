
```bash
az group create --name wvd-network --location westeurope

az deployment group create --resource-group wvd-network --template-file template.json --parameters parameters.json
```
