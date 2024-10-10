param location string = 'italynorth'
param romePoolSize int = 1
param milanPoolSize int = 2
param vmSku string = 'Standard_D2_v5'

var vnetName = 'avd-playground-net'
var romeSubnetName = 'rome-hosts-subnet'
var milanSubnetName = 'milan-hosts-subnet'

var vmUsername = 'nicola'
var vmPassword = 'password.123'

var imagePublisher = 'MicrosoftWindowsDesktop'
var imageOffer = 'office-365'
var imageSku = 'win11-24h2-avd-m365'
var imageVersion = 'latest'

var domainToJoin = 'demo.nicold'
var domainAdministratorAccountUserName = 'user01@demo.nicold'
var domainAdministratorAccountPassword = 'pa.123.assword' 

// reference to existing resources
resource vnet 'Microsoft.Network/virtualNetworks@2022-11-01' existing = {
  name: vnetName
}

resource romeSubnet 'Microsoft.Network/virtualNetworks/subnets@2022-11-01' existing = {
  parent: vnet
  name: romeSubnetName
}

resource milanSubnet 'Microsoft.Network/virtualNetworks/subnets@2022-11-01' existing = {
  parent: vnet
  name: milanSubnetName
}

// create rome VMs
resource vmRomeDisk 'Microsoft.Compute/disks@2019-07-01' = [for i in range(0, romePoolSize): {
  name: 'rome${i}disk'
  location: location
  properties: {
    creationData: { createOption: 'Empty' }
    diskSizeGB: 128
  }
}]

resource vmRomeNIC 'Microsoft.Network/networkInterfaces@2022-11-01' =  [for i in range(0, romePoolSize): {
  name: 'rome-${i}-nic'
  location: location
  properties: {
    ipConfigurations: [ {
        name: 'ipconfig1'
        properties: {
          subnet: { id: romeSubnet.id}
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
  }
}]

resource vmRome 'Microsoft.Compute/virtualMachines@2022-11-01' = [for i in range(0, romePoolSize): {
  name: 'rome-${i}-vm'
  location: location
  dependsOn: []
  properties: {
    hardwareProfile: { vmSize: vmSku }
    storageProfile: {
      imageReference: { publisher: imagePublisher, offer: imageOffer, sku: imageSku, version: imageVersion }
      dataDisks: [ {
          lun: 0
          name: vmRomeDisk[i].name
          createOption: 'Attach'
          managedDisk: { id: vmRomeDisk[i].id }
        }
      ]
    }
    osProfile: {
      computerName: 'rome-${i}-vm'
      adminUsername: vmUsername
      adminPassword: vmPassword
      windowsConfiguration: { enableAutomaticUpdates: true }
    }
    networkProfile: {
      networkInterfaces: [ {
          id: vmRomeNIC[i].id
        }
      ]
    }
  }
}]

questo step non è stato ancora testato
resource joinRomeToDomain 'Microsoft.Compute/virtualMachines/extensions@2021-11-01' = [for i in range(0, romePoolSize): {
  name: 'rome-${i}-vm/joindomain'
  location: location
  properties: {
    publisher: 'Microsoft.Compute'
    type: 'JsonADDomainExtension'
    typeHandlerVersion: '1.3'
    autoUpgradeMinorVersion: true
    settings: {
      name: domainToJoin
      //ouPath: ouPath
      user: domainAdministratorAccountUserName
      restart: 'true'
      options: '3'
      NumberOfRetries: '4'
      RetryIntervalInMilliseconds: '30000'
    }
    protectedSettings: {
      password: domainAdministratorAccountPassword
    }
  }
  dependsOn: [
    vmRome[i]
  ]
}]


// create milan VMs
resource vmMilanDisk 'Microsoft.Compute/disks@2019-07-01' = [for i in range(0, milanPoolSize): {
  name: 'milan${i}disk'
  location: location
  properties: {
    creationData: { createOption: 'Empty' }
    diskSizeGB: 128
  }
}]

resource vmMilanNIC 'Microsoft.Network/networkInterfaces@2022-11-01' =  [for i in range(0, milanPoolSize): {
  name: 'milan-${i}-nic'
  location: location
  properties: {
    ipConfigurations: [ {
        name: 'ipconfig1'
        properties: {
          subnet: { id: milanSubnet.id}
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
  }
}]

resource vmMilan 'Microsoft.Compute/virtualMachines@2022-11-01' = [for i in range(0, milanPoolSize): {
  name: 'milan-${i}-vm'
  location: location
  dependsOn: []
  properties: {
    hardwareProfile: { vmSize: vmSku }
    storageProfile: {
      imageReference: { publisher: imagePublisher, offer: imageOffer, sku: imageSku, version: imageVersion }
      dataDisks: [ {
          lun: 0
          name: vmMilanDisk[i].name
          createOption: 'Attach'
          managedDisk: { id: vmMilanDisk[i].id }
        }
      ]
    }
    osProfile: {
      computerName: 'milan-${i}-vm'
      adminUsername: vmUsername
      adminPassword: vmPassword
      windowsConfiguration: { enableAutomaticUpdates: true }
    }
    networkProfile: {
      networkInterfaces: [ {
          id: vmMilanNIC[i].id
        }
      ]
    }
  }
}]

