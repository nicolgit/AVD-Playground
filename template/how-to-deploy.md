
```bash
az group create --name wvd-network --location westeurope

az deployment group create --resource-group wvd-network --template-file template.json --parameters parameters.json
```


```powershell

New-AzResourceGroupDeployment -ResourceGroupName <resource-group-name> -TemplateFile <path-to-template-or-bicep>
```