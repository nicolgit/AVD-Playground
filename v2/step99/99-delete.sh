az ad user delete --id user01@duckiesfarm.com
az ad user delete --id user02@duckiesfarm.com
az ad user delete --id user03@duckiesfarm.com

az ad group delete --group "AAD DC Administrators"

az group delete --name avd-playground --force-detion-types Microsoft.Compute/virtualMachines --yes