import boto3

client = boto3.client('lambda', region_name='us-east-1')

lambda_name = 'dbWrite'
response = client.get_function(FunctionName=lambda_name)

print(response)
