@minLength(3)
@maxLength(51)

param prefix string = 'anton42'
param   storageName string = '${prefix}${uniqueString(resourceGroup().id)}'
param location string = resourceGroup().location
param globalRedundancy bool



resource storageAccount 'Microsoft.Storage/storageAccounts@2022-05-01'    = {
  name: storageName
  location: location
  sku: {
    name: globalRedundancy ? 'Standard_LRS' : 'Standard_GRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}

resource containerGroup 'Microsoft.ContainerInstance/containerGroups@2021-03-01' = {
  name: storageName
  location: location
  properties: {
    containers: [
      {
        name: 'ruslanisgone'
        properties: {
          image: 'mcr.microsoft.com/azuredocs/aci-helloworld:latest'
          ports: [
            {
              port: 80
            }
          ]
          resources: {
            requests: {
              cpu: 1
              memoryInGB: 4
            }
          }
        }
      }
    ]
    restartPolicy: 'OnFailure'
    osType: 'Linux'
    ipAddress: {
      type: 'Public'
      ports: [
        {
          protocol: 'TCP'
          port: 80
        }
      ]
    }
  }
}


output stringOutput string = storageAccount.id
output storagename string = storageAccount.properties.primaryEndpoints.blob
