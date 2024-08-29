param appName string
@allowed(['dev', 'prod'])
param environment string
param location string

var appServiceProperties = {
  serverFarmId: appServicePlan.id
  httpsOnly: true
  siteConfig: {
    http20Enabled: true
    linuxFxVersion: 'DOTNETCORE|8.0'
    alwaysOn: true
    ftpsState: 'Disabled'
    minTlsVersion: '1.2'
    webSocketsEnabled: true
    requestTracingEnabled: true
    detailedErrorLoggingEnabled: true
    httpLoggingEnabled: true
  }
}

resource appServicePlan 'Microsoft.Web/serverfarms@2023-12-01' = {
  name: 'asp-${appName}-${environment}'
  location: location
  sku: {
    name: 'F1'
  }
  kind: 'linux'
  properties: {
    reserved: true
  }
}

resource appService 'Microsoft.Web/sites@2023-12-01' = {
  name: 'app-${appName}-${environment}'
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: appServiceProperties
}

resource appSettings 'Microsoft.Web/sites/config@2023-12-01' = {
  name: 'appsettings'
  kind: 'string'
  parent: appService
  properties: {
    ASPNETCORE_ENVIRONMENT: environment
  }
}

resource appServiceSlot 'Microsoft.Web/sites/slots@2023-12-01' = {
  location: location
  parent: appService
  name: 'slot'
  identity: {
    type: 'SystemAssigned'
  }
  properties: appServiceProperties
}

resource appServiceSlotSetting 'Microsoft.Web/sites/slots/config@2023-12-01' = {
  name: 'appsettings'
  kind: 'string'
  parent: appServiceSlot
  properties: {
    ASPNETCORE_ENVIRONMENT: environment
  }
}
