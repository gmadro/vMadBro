import boto3
import zipfile
import os
import shutil
import yaml
import time

#Instantiate AWS classes
cf = boto3.client('cloudformation')
s3 = boto3.client('s3')

def main():
    print('(C)reate or (D)elete LambdaStack?:')
    cORd = input().lower()

    if cORd == 'c':
        Create_Lambda()
    elif cORd == 'create':
        Create_Lambda()
    elif cORd == 'd':
        Delete_Lambda()
    elif cORd == 'delete':
        Delete_Lambda()
    else:
        print('Bad option. Try again!')

def Create_Lambda():
    print('Enter name of stack:')
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
    cf_s3_bucket = stack + '-cf'.lower()
    print('Creating bucket ' + cf_s3_bucket + '...')
    s3.create_bucket(Bucket=cf_s3_bucket)
    lambda_s3_bucket = stack + '-lambda'.lower()
    print('Creating bucket ' + lambda_s3_bucket + '...')
    s3.create_bucket(Bucket=lambda_s3_bucket)

    stack_file = stack + '.yaml'
    cf_tmpl_url = 'https://' + cf_s3_bucket + '.s3.amazonaws.com/' + stack_file
    lambda_zip = stack + '.zip'

    #Copy Base Lambda script to new file and zip
    print('Copying ' + lambda_base + ' to ' + lambda_file + '...')
    shutil.copy(lambda_base, lambda_file)
    print('Zipping ' + lambda_file + ' into ' + lambda_zip + '...')
    with zipfile.ZipFile(lambda_zip, 'w') as azip:
            azip.write(lambda_file)

    #Upload stack and lambda code to S3
    print('Uploading ' + cf_base + ' to ' + cf_s3_bucket + '...')
    s3.upload_file(cf_base, cf_s3_bucket, stack_file)
    print('Uploading ' + lambda_zip + ' to ' + lambda_s3_bucket + '...')
    s3.upload_file(lambda_zip, lambda_s3_bucket, lambda_zip)
    print('Creating stack ' + stack + '...')
    cf.create_stack(StackName=stack, TemplateURL=cf_tmpl_url)

    #Clean up local resources
    print('Removing ' + lambda_file + '...')
    os.remove(lambda_file)
    print('Removing ' + lambda_zip + '...')
    os.remove(lambda_zip)

def Delete_Lambda():
    print('List of Stacks:')

    #Get list of CloudFormation stacks
    stack_filter = ['ROLLBACK_COMPLETE', 'CREATE_COMPLETE']
    ss = cf.list_stacks(StackStatusFilter=stack_filter)['StackSummaries']
    for x in ss:
        print(x['StackName'])

    print('Which stack to delete? (case sensative)')
    stack_purge = input()

    #Remove CloudFormation stack and associated S3 Buckets
    print('Deleting stack: ' + stack_purge + '...')
    cf.delete_stack(StackName=stack_purge)
    print('Deleting file: ' + stack_purge + '.yaml...')
    s3.delete_object(Bucket=stack_purge + '-cf', Key=stack_purge + '.yaml')
    time.sleep(1)
    print('Deleting bucket: ' + stack_purge + '-cf...')
    s3.delete_bucket(Bucket=stack_purge + '-cf')
    print('Deleting file: ' + stack_purge + '.zip...')
    s3.delete_object(Bucket=stack_purge + '-lambda', Key=stack_purge + '.zip')
    time.sleep(1)
    print('Deleting bucket: ' + stack_purge + '-lambda...')
    s3.delete_bucket(Bucket=stack_purge + '-lambda')

main()