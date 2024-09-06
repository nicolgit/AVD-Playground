
# step 1
this step creates:
* virtual network
* bastion
* Entra id domain services

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fnicolgit%2FAVD-Playground%2Fmain%2Fv2%2Fstep1%2Fstep1.json) 

# step 2 *manual*
* wait ADDS provisioning
* fix virtual network DNS as reccomended by ADDS
* create user01 user02 and user03 AND add user01 to ADDS management group: Open azure cloud shell and type the following
  * `source 00-variables-duckiesfarm.sh`* 
  * `source 01-users.sh `

# step 3
this step creates:
* create Roma Host pool
* create Roma Desktop Application Group
* create Roma remoteapp Application Group 
* create Milano Host pool
* create Milano Desktop Application Group
* create Milano remoteapp Application Group
* create azure storage for fxlogix and app attach

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fnicolgit%2FAVD-Playground%2Fmain%2Fv2%2Fstep3%2Fstep3.json) 

# step 4 *manual*
* add virtual machines to pools


# applications
## appattach
* concept: <https://learn.microsoft.com/en-us/azure/virtual-desktop/publish-applications-stream-remoteapp?tabs=portal>
* howto: <https://learn.microsoft.com/en-us/azure/virtual-desktop/app-attach-setup?tabs=portal&pivots=app-attach>
* create msix image: https://learn.microsoft.com/en-us/azure/virtual-desktop/app-attach-create-msix-image?tabs=cim 
* download MSIXmgr:<https://aka.ms/msixmgr>