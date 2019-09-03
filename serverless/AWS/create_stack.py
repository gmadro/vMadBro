import boto3
import requests
import time
import zipfile
import os
import shutil
import yaml

#Instantiate AWS module
cf = boto3.client('cloudformation')
s3 = boto3.client('s3')

print('Enter name of stack')
stack = input()

cwd = os.getcwd()

#Open app config yaml
with open(cwd + '/app_config.yaml') as f:
    app_settings = yaml.safe_load(f)
settings = app_settings['settings']

#Set values imported from app_config.yaml
api_base = settings['api_base']
cf_base = settings['cf_base']
cf_s3_bucket = settings['cf_s3_bucket']
lambda_base = settings['lambda_base']
lambda_s3_bucket = settings['lambda_s3_bucket']
lambda_file = settings['lambda_file']

stack_file = stack + '.yaml'
cf_tmpl_url = 'https://' + cf_s3_bucket + '.s3.amazonaws.com/' + stack_file
lambda_zip = stack + '.zip'

#Copy Base Lambda script to new file and zip
shutil.copy(lambda_base, lambda_file)
with zipfile.ZipFile(lambda_zip, 'w') as azip:
        azip.write(lambda_file)

#Upload stack and lambda code to S3
s3.upload_file(cwd + '/' + cf_base,cf_s3_bucket,stack_file)
s3.upload_file(cwd + '/' + lambda_zip,lambda_s3_bucket, lambda_zip)

cf.create_stack(StackName=stack, TemplateURL=cf_tmpl_url)

app_url = api_base + stack + "/"
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
