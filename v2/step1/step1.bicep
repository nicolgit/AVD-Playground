param location string = 'italynorth'

var domainservicesName = 'avd-domain-services'
var domainName = 'demo.nicold'

param domainServicesSubnetName string = 'dc-subnet'
var domainServicesNSGName = '${domainServicesSubnetName}-nsg'

var avdnet = 'avd-playground-net'
var bastionName = 'avd-bastion'
var bastionIPName = '${bastionName}-ip'

resource addsnsg 'Microsoft.Network/networkSecurityGroups@2020-11-01' = {
  name: domainServicesNSGName
  location: location
  properties: {
    securityRules: [
      {
        name: 'AllowPSRemoting'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '5986'
          sourceAddressPrefix: 'AzureActiveDirectoryDomainServices'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 301
          direction: 'Inbound'
        }
      }
      {
        name: 'AllowRD'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: 'CorpNetSaw'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 201
          direction: 'Inbound'
        }
      }
    ]
  }
}

var subnets = [
    { name: 'AzureBastionSubnet', properties: { addressPrefix: '10.30.1.0/24' } }
    { name: 'hosts01-subnet', properties: { addressPrefix: '10.30.3.0/24' } }
    { name: 'hosts02-subnet', properties: { addressPrefix: '10.30.4.0/24' } }
    { name: domainServicesSubnetName
      properties: { 
        addressPrefix: '10.30.2.0/24' 
        networkSecurityGroup: {
          id: addsnsg.id
        }
      } 
    }
  ]

resource hubLabVnet 'Microsoft.Network/virtualNetworks@2019-09-01' = {
  name: avdnet
  location: location
  properties: { addressSpace: { addressPrefixes: [ '10.30.0.0/16' ] }
    subnets: subnets
  }
}

resource bastionHubIP 'Microsoft.Network/publicIPAddresses@2019-09-01' = {
  name: bastionIPName
  location: location
  sku: { name: 'Standard' }
  properties: { publicIPAllocationMethod: 'Static' }
}

resource bastion 'Microsoft.Network/bastionHosts@2019-09-01' = {
  name: bastionName
  location: location
  dependsOn: [ hubLabVnet ]
  properties: {
    ipConfigurations: [ {
        name: 'ipconfig1'
        properties: {
          subnet: { id: resourceId('Microsoft.Network/virtualNetworks/subnets', avdnet, 'AzureBastionSubnet') }
          publicIPAddress: { id: bastionHubIP.id }
        }
      }
    ]
  }
}

resource domainservices 'Microsoft.AAD/domainServices@2022-12-01' = {
  name: domainservicesName
  location: location
  properties: {
  domainName: domainName
  filteredSync: 'Disabled'
  domainConfigurationType: 'FullySynced'
  replicaSets: [
    {
      subnetId: resourceId('Microsoft.Network/virtualNetworks/subnets', avdnet, domainServicesSubnetName)
      location: location
    }
  ]
  sku: 'Standard'
  }
}
