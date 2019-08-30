import requests

gcp_project = 'MVM01'

app_url = 'https://www.googleapis.com/deploymentmanager/v2beta1/projects/' + gcp_project + '/global/deployments'

r = request.get(url = app_url, verify=False)
print(r.text)
