import boto3
import requests
import time
import zipfile
import os
import shutil

cf = boto3.client('cloudformation')
s3 = boto3.client('s3')

#Define the stack
print('Enter name of stack')
stack = input()
stack_file = stack + '.yaml'
cwd = os.getcwd()
lambda_base = 'lambda_test.py'
lambda_file = 'index.py'
lambda_zip = stack + '.zip'

#Copy Base Lambda script to new file and zip
shutil.copy(lambda_base, lambda_file)
with zipfile.ZipFile(lambda_zip, 'w') as azip:
        azip.write(lambda_file)

s3.upload_file('/home/vMadBro/serverless/cf.yaml','vmadbro-cf',stack_file)
s3.upload_file('/home/vMadBro/serverless/' + lambda_zip,'vmadbro-lambda-code', lambda_zip)
cf_tmpl_url = 'https://vmadbro-cf.s3.amazonaws.com/' + stack_file
cf.create_stack(StackName=stack, TemplateURL=cf_tmpl_url)

app_url = "https://api.vmadbro.com/" + stack + "/"

print("API created at: " + app_url)

#Set function test values
print('Enter first key value')
v1 = input()
print('Enter second key value')
v2 = input()

json_in = {
        "k1":v1,
        "k2":v2
}

#Test the stack
test_num = 0

while True:
    r = requests.post(url = app_url, json=json_in, verify=False)
    test_num = test_num + 1
    if (r.status_code == 200):
        print("API result: " + r.text)
        
        #Tear down stack
        print("Deleting stack: " + stack)
        cf.delete_stack(StackName=stack)
        os.remove(lambda_file)
        os.remove(lambda_zip)
        break
    print(r.status_code)
    print("Attempt: " + str(test_num) + " Retrying attempt in 1s")
    time.sleep(1)
