param location string = resourceGroup().location
param romePoolSize int = 2

var vnetName = 'avd-playground-net'
var romeSubnetName = 'rome-hosts-subnet'

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
  scope: resourceGroup()
}

resource romeSubnet 'Microsoft.Network/virtualNetworks/subnets@2022-11-01' existing = {
  parent: vnet
  name: romeSubnetName
}

ERRORE 
//Value for reference id is missing. Path properties.ipConfigurations[0].properties.subnet. (Code: MissingJsonReferenceId)
resource vmRomeNIC 'Microsoft.Network/networkInterfaces@2022-11-01' = [for i in range(0, romePoolSize): {
  name: 'rome${i}nic'
  location: location
  properties: {
    ipConfigurations: [ {
        name: 'ipconfig1'
        properties: {
          subnet: romeSubnet
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
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
