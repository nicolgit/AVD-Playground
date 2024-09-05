
# step 1
creates
* virtual network
* bastion
* Entra id domain services


# step 2 *manual*
* wait ADDS provisioning
* fix virtual network DNS as reccomended by ADDS
* create user01 user02 and user03 AND add user01 to ADDS management group
  * `source 00-variables-duckiesfarm.sh`* 
  * `source 01-users.sh `

# step 3
* create Roma Host pool
* create Roma Desktop Application Group
* create Roma remoteapp Application Group 
* create Milano Host pool
* create Milano Desktop Application Group
* create Milano remoteapp Application Group
* create azure storage for fxlogix and app attach

# step 4
* add virtual machines to pools


# Extensions
## How to configure appattach
<https://learn.microsoft.com/en-us/azure/virtual-desktop/app-attach-setup?tabs=portal&pivots=app-attach>
