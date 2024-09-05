param location string = 'italynorth'

var domainservicesName = 'avd-domain-services'
var domainName = 'demo.nicold'

param domainServicesSubnetName string = 'dc-subnet'
var domainServicesNSGName = '${domainServicesSubnetName}-nsg'

var avdnet = 'avd-playground-net'
var bastionName = 'avd-bastion'
var bastionIPName = '${bastionName}-ip'

var subnets = [
    { name: 'AzureBastionSubnet', properties: { addressPrefix: '10.30.1.0/24' } }
    { name: domainServicesSubnetName, properties: { addressPrefix: '10.30.2.0/24' } }
    { name: 'hosts01-subnet', properties: { addressPrefix: '10.30.3.0/24' } }
    { name: 'hosts02-subnet', properties: { addressPrefix: '10.30.4.0/24' } }
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

  // https://github.com/Azure/azure-quickstart-templates/blob/master/quickstarts/microsoft.network/aad-domainservices/main.bicep

  var PSRemotingSlicePIPAddresses = [
    '52.180.179.108'
    '52.180.177.87'
    '13.75.105.168'
    '52.175.18.134'
    '52.138.68.41'
    '52.138.65.157'
    '104.41.159.212'
    '104.45.138.161'
    '52.169.125.119'
    '52.169.218.0'
    '52.187.19.1'
    '52.187.120.237'
    '13.78.172.246'
    '52.161.110.169'
    '52.174.189.149'
    '40.68.160.142'
    '40.83.144.56'
    '13.64.151.161'
  ]
  var RDPIPAddresses = [
    '207.68.190.32/27'
    '13.106.78.32/27'
    '13.106.174.32/27'
    '13.106.4.96/27'
  ]
  
  var PSRemotingSliceTIPAddresses = [
    '52.180.183.67'
    '52.180.181.39'
    '52.175.28.111'
    '52.175.16.141'
    '52.138.70.93'
    '52.138.64.115'
    '40.80.146.22'
    '40.121.211.60'
    '52.138.143.173'
    '52.169.87.10'
    '13.76.171.84'
    '52.187.169.156'
    '13.78.174.255'
    '13.78.191.178'
    '40.68.163.143'
    '23.100.14.28'
    '13.64.188.43'
    '23.99.93.197'
  ]
  
  resource nsg 'Microsoft.Network/networkSecurityGroups@2020-11-01' = {
    name: domainServicesNSGName
    location: location
    properties: {
      securityRules: [
        {
          name: 'AllowPSRemotingSliceP'
          properties: {
            protocol: 'Tcp'
            sourcePortRange: '*'
            destinationPortRange: '5986'
            sourceAddressPrefixes: PSRemotingSlicePIPAddresses
            destinationAddressPrefix: '*'
            access: 'Allow'
            priority: 301
            direction: 'Inbound'
          }
        }
        {
          name: 'AllowRDP'
          properties: {
            protocol: 'Tcp'
            sourcePortRange: '*'
            destinationPortRange: '3389'
            sourceAddressPrefixes: RDPIPAddresses
            destinationAddressPrefix: '*'
            access: 'Allow'
            priority: 201
            direction: 'Inbound'
          }
        }
        {
          name: 'AllowSyncWithAzureAD'
          properties: {
            protocol: 'Tcp'
            sourcePortRange: '*'
            destinationPortRange: '443'
            sourceAddressPrefix: '*'
            destinationAddressPrefix: '*'
            access: 'Allow'
            priority: 101
            direction: 'Inbound'
          }
        }
        {
          name: 'AllowPSRemotingSliceT'
          properties: {
            protocol: 'Tcp'
            sourcePortRange: '*'
            destinationPortRange: '5986'
            sourceAddressPrefixes: PSRemotingSliceTIPAddresses
            destinationAddressPrefix: '*'
            access: 'Allow'
            priority: 302
            direction: 'Inbound'
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
