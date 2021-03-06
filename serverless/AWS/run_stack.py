import boto3
import requests
import time
import zipfile
import os
import shutil
import yaml
from colorama import Fore, Back, Style

#Instantiate AWS classes
lmbda = boto3.client('lambda')
s3 = boto3.client('s3')

print('Enter name of app')
app = input()

#Set working dir and app dir
cwd = os.getcwd()
cwd_count = len(cwd.split('/'))
app_dir_items = cwd.split('/')[0:cwd_count - 1]
s = '/'
app_dir = s.join(app_dir_items)

#Open app config yaml
with open(app_dir + '/AWS_app_config.yaml') as f:
    app_settings = yaml.safe_load(f)
settings = app_settings['settings']

#Set values imported from app_config.yaml
api_base = settings['api_base']
lambda_base_new = app_dir + '/' + settings['lambda_base_new']
lambda_s3_bucket = settings['lambda_s3_bucket']
lambda_file = settings['lambda_file']
lambda_static_name = settings['lambda_static_name']
lambda_static_url = settings['lambda_static_url']

lambda_zip = app + '.zip'

#Copy Base Lambda script to new file and zip
shutil.copy(lambda_base_new, lambda_file)
with zipfile.ZipFile(lambda_zip, 'w') as azip:
    azip.write(lambda_file)

#Upload lambda code to S3
s3.upload_file(cwd + '/' + lambda_zip, lambda_s3_bucket, lambda_zip)

#Update Lambda code
lmbda.update_function_code(
    FunctionName = lambda_static_name,
    S3Bucket = lambda_s3_bucket,
    S3Key = lambda_zip,
    Publish = True
)

#Set function test values
print('Enter first key value:')
v1 = input()
print('Enter second key value:')
v2 = input()

json_in = {
        "k1":v1,
        "k2":v2
}

print('Running new code:')

url = lambda_static_url

r = requests.post(url, json=json_in, verify=False)
print(Fore.GREEN + "API result: " + Style.BRIGHT + r.text)
print(Style.RESET_ALL)

#Cleanup app
os.remove(lambda_file)
os.remove(lambda_zip)
s3.delete_object(
    Bucket = lambda_s3_bucket,
    Key = lambda_zip
)