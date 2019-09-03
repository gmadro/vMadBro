import requests
import json

subId = ''
rgName = ''
depName = ''

tmplUri = ''
paramUri = ''

with open('app_resource.json') as json_file:
  json_in = json.load(json_file)

app_url = 'https://management.azure.com/subscriptions/' + subId + '/resourcegroups/' + rgName + '/providers/Microsoft.Resources/deployments/' + depName + '?api-version=2019-05-01'

r = requests.put(url = app_url, json = json_in, verify=False)
print(r.text)
