param location string = 'westeurope'
param romehostpoolName string = 'rome-hostpool'
param romePreferredAppGroupType string = 'Desktop'
param romeDesktopGroupName string = 'roma-desktop'
param romeRemoteAppGroupName string = 'roma-remoteapp'
param romeWorkspaceName string = 'roma-workspace'

param milanhostpoolName string = 'milan-hostpool'
param milanPreferredAppGroupType string = 'RailApplications'
param milanDesktopGroupName string = 'milano-desktop'
param milanRemoteAppGroupName string = 'milano-remoteapp'
param milanWorkspaceName string = 'milano-workspace'

param storageName string = 'avdplaygroundstoragenicolod'

resource romaHostpool 'Microsoft.DesktopVirtualization/hostPools@2024-04-03' = {
  name: romehostpoolName
  location: location
  properties: {
    hostPoolType: 'Pooled'
    loadBalancerType: 'BreadthFirst'
    preferredAppGroupType: romePreferredAppGroupType
  }
}

resource romeDesktopGroup 'Microsoft.DesktopVirtualization/applicationGroups@2024-04-03' = {
  name: romeDesktopGroupName
  location: location
  properties: {
    applicationGroupType: 'Desktop'
    hostPoolArmPath: romaHostpool.id
  }
}

resource romeRemoteAppGroup 'Microsoft.DesktopVirtualization/applicationGroups@2024-04-03' = {
  name: romeRemoteAppGroupName
  location: location
  properties: {
    applicationGroupType: 'RemoteApp'
    hostPoolArmPath: romaHostpool.id
  }
}

resource romeWorkspace 'Microsoft.DesktopVirtualization/workspaces@2024-04-03' = {
  name: romeWorkspaceName
  location: location
  properties: {
    applicationGroupReferences: [
      romeDesktopGroup.id
      romeRemoteAppGroup.id
    ]
  }
}

resource milanHostpool 'Microsoft.DesktopVirtualization/hostPools@2024-04-03' = {
  name: milanhostpoolName
  location: location
  properties: {
    hostPoolType: 'Pooled'
    loadBalancerType: 'BreadthFirst'
    preferredAppGroupType: milanPreferredAppGroupType
  }
}

resource milanDesktopGroup 'Microsoft.DesktopVirtualization/applicationGroups@2024-04-03' = {
  name: milanDesktopGroupName
  location: location
  properties: {
    applicationGroupType: 'Desktop'
    hostPoolArmPath: milanHostpool.id
  }
}

resource milanRemoteAppGroup 'Microsoft.DesktopVirtualization/applicationGroups@2024-04-03' = {
  name: milanRemoteAppGroupName
  location: location
  properties: {
    applicationGroupType: 'RemoteApp'
    hostPoolArmPath: milanHostpool.id
  }
}

resource milanWorkspace 'Microsoft.DesktopVirtualization/workspaces@2024-04-03' = {
  name: milanWorkspaceName
  location: location
  properties: {
    applicationGroupReferences: [
      milanDesktopGroup.id
      milanRemoteAppGroup.id
    ]
  }
}

resource storageAvd 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    azureFilesIdentityBasedAuthentication: {
      activeDirectoryProperties: {
        domainGuid: subscription().tenantId
        domainName: 'demo.nicold'
      }
      defaultSharePermission: 'StorageFileDataSmbShareReader'
      directoryServiceOptions: 'AADDSS'
    }
  }
}
