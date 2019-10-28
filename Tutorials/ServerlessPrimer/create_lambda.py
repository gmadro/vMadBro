import boto3
import zipfile
import os
import shutil
import yaml

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
    s3.create_bucket(Bucket=cf_s3_bucket)
    lambda_s3_bucket = stack + '-lambda'.lower()
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

    #Clean up local resources
    os.remove(lambda_file)
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
    cf.delete_stack(StackName=stack_purge)
    s3.delete_object(Bucket=stack_purge + '-cf', Key=stack_purge)
    s3.delete_bucket(Bucket=stack_purge + '-cf')
    s3.delete_object(Bucket=stack_purge + '-lambda', Key=stack_purge)
    s3.delete_bucket(Bucket=stack_purge + '-lambda')

main()