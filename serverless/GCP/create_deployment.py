import requests

json_in = {
        "name":"GCPtest01",
        "target": {
          "config": {
            "content" : "imports:\n- path: test_tmpl\n\nresources:\n- name: Test01\n type: test_tmpl "
          },
          "imports: [
            {
              "content":"resources:n- name: test deploy\n type: compute.v1.instance\n properties:\n zone: us-central1-a\n machineType: "
              "name":"test_tmpl"
            }
          ]
        }
}

gcp_project = 'MVM01'

app_url = 'https://www.googleapis.com/deploymentmanager/v2/projects/' + gcp_project + '/global/deployments'

r = requests.post(url = app_url, json = json_in verify=False)
print(r.text)
