param location string = 'italynorth'
param romePoolSize int = 2

var vnetName = 'avd-playground-net'
var romeSubnetName = 'rome-hosts-subnet'

var vmUsername = 'nicola'
var vmPassword = 'password.123'

var vmSku = 'Standard_D2s_v3'

var imagePublisher = 'MicrosoftWindowsDesktop'
var imageOffer = 'office-365'
var imageSku = 'win11-24h2-avd-m365'
var imageVersion = 'latest'

resource vmRomeDisk 'Microsoft.Compute/disks@2019-07-01' = [for i in range(0, romePoolSize): {
  name: 'rome${i}disk'
  location: location
  properties: {
    creationData: { createOption: 'Empty' }
    diskSizeGB: 128
  }
}]

resource vnet 'Microsoft.Network/virtualNetworks@2022-11-01' existing = {
  name: vnetName
}

resource romeSubnet 'Microsoft.Network/virtualNetworks/subnets@2022-11-01' existing = {
  parent: vnet
  name: romeSubnetName
}


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

/*
//VM HUB


resource vmHubNIC 'Microsoft.Network/networkInterfaces@2019-09-01' = if (deployVmHub) {
  name: vmHubNICName
  location: location
  dependsOn: [ hubLabVnet ]
  properties: {
    ipConfigurations: [ {
        name: 'ipconfig1'
        properties: {
          subnet: { id: resourceId('Microsoft.Network/virtualNetworks/subnets', hublabName, 'DefaultSubnet') }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
  }
}

resource vmHub 'Microsoft.Compute/virtualMachines@2019-07-01' = if (deployVmHub) {
  name: vmHubName
  location: location
  dependsOn: []
  properties: {
    hardwareProfile: { vmSize: virtualMachineSKU }
    storageProfile: {
      imageReference: { publisher: 'MicrosoftWindowsServer', offer: 'WindowsServer', sku: '2019-Datacenter', version: 'latest' }
      dataDisks: [ {
          lun: 0
          name: vmHubDiskName
          createOption: 'Attach'
          managedDisk: { id: vmHubDisk.id }
        }
      ]
    }
    osProfile: {
      computerName: vmHubName
      adminUsername: username
      adminPassword: password
      windowsConfiguration: { enableAutomaticUpdates: true }
    }
    networkProfile: {
      networkInterfaces: [ {
          id: vmHubNIC.id
        }
      ]
    }
  }
}

resource vmHubAutoshutdown 'microsoft.devtestlab/schedules@2018-09-15' = if (deployVmHub) {
  name: vmHubAutoshutdownName
  location: location
  properties: {
    status: 'Enabled'
    taskType: 'ComputeVmShutdownTask'
    timeZoneId: 'UTC'
    dailyRecurrence: { time: '20:00' }
    notificationSettings: { status: 'Disabled' }
    targetResourceId: vmHub.id
  }
}
//END VM HUB
*/
