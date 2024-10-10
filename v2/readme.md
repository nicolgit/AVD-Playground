


# step 1
this step creates:
* virtual network
* nsg required by entra ds to work
* bastion
* Entra id domain services

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fnicolgit%2FAVD-Playground%2Fmain%2Fv2%2Fstep1%2Fstep1.json) 

# step 2
this step creates:
* create Roma Host pool
* create Roma Desktop Application Group
* create Roma remoteapp Application Group 
* create Milano Host pool
* create Milano Desktop Application Group
* create Milano remoteapp Application Group
* create azure storage for fxlogix and app attach

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fnicolgit%2FAVD-Playground%2Fmain%2Fv2%2Fstep2%2Fstep2.json) 

# step 3 *manual*
* wait ADDS provisioning
* fix virtual network DNS as reccomended by ADDS
* create user01 user02 and user03 AND add user01 to ADDS management group: Open azure cloud shell and type the following
  * `source 00-variables-duckiesfarm.sh`
  * `source 01-users.sh `

# step 4
* create rome pool with 1 machine
* create milan pool with 2 machines

# step 5 (TODO)

 https://tighetec.co.uk/2022/07/01/avd-deployment-azure-ad-join-bicep/ 

* add all machines to Entra ID Domain Services
* add rome machines to Rome host pool
* add milan machines to Milan host pool

# step 99 delete everything
execute `source 99-delete.sh` to delete users, groups and "avd-playground" resource group 

# applications

## appattach
* concept: <https://learn.microsoft.com/en-us/azure/virtual-desktop/publish-applications-stream-remoteapp?tabs=portal>
* howto: <https://learn.microsoft.com/en-us/azure/virtual-desktop/app-attach-setup?tabs=portal&pivots=app-attach>
* create msix image: https://learn.microsoft.com/en-us/azure/virtual-desktop/app-attach-create-msix-image?tabs=cim 
* download MSIXmgr:<https://aka.ms/msixmgr>