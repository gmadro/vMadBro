import boto3
import requests

#Set function test values
print('Enter first key value')
v1 = input()
print('Enter second key value')
v2 = input()

json_in = {
        "k1":v1,
        "k2":v2
}

url = 'https://76eumn73g9.execute-api.us-east-1.amazonaws.com/Hybrid1-Test'

r = requests.post(url, json=json_in, verify=False)
print("API result: " + r.text)