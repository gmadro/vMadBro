import requests

subId = ''
rgName = ''
depName = ''

tmplUri = ''
paramUri = ''

json_in = {
  "properties":{
    "templateLink": {
      "uri": tmplUri,
      "contentVersion": "1.0.0.0"
    },
    "parametersLink": {
      "uri":paramUri,
      "contentVersion":"1.0.0.0"
    },
    "mode":"Complete"
  }
}

app_url = 'https://management.azure.com/subscriptions/' + subId + '/resourcegroups/' + rgName + '/providers/Microsoft.Resources/deployments/' + depName + '?api-version=2019-05-01'

r = requests.put(url = app_url, json = json_in verify=False)
print(r.text)
