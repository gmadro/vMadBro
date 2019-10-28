import boto3
import zipfile
import os
import shutil
import yaml

#Instantiate AWS classes
cf = boto3.client('cloudformation')
s3 = boto3.client('s3')

print('Enter name of stack')
stack = input()

#Open app config yaml
with open('app_config.yaml') as f:
    app_settings = yaml.safe_load(f)
settings = app_settings['settings']

#Set values imported from app_config.yaml
cf_base = settings['cf_base']
lambda_base = settings['lambda_base']
lambda_file = settings['lambda_file']

#Create CloudFormation template and Lambda code buckets
cf_s3_bucket = stack + '-cf'
s3.create_bucket(Bucket=cf_s3_bucket)
lambda_s3_bucket = stack + '-lambda'
s3.create_bucket(Bucket=lambda_s3_bucket)

stack_file = stack + '.yaml'
cf_tmpl_url = 'https://' + cf_s3_bucket + '.s3.amazonaws.com/' + stack_file
lambda_zip = stack + '.zip'

#Copy Base Lambda script to new file and zip
shutil.copy(lambda_base, lambda_file)
with zipfile.ZipFile(lambda_zip, 'w') as azip:
        azip.write(lambda_file)

#Upload stack and lambda code to S3
s3.upload_file(cf_base, cf_s3_bucket, stack_file)
s3.upload_file(lambda_zip, lambda_s3_bucket, lambda_zip)

cf.create_stack(StackName=stack, TemplateURL=cf_tmpl_url)
