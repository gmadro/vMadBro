import boto3
import requests
import time
cf = boto3.client('cloudformation')
s3 = boto3.client('s3')

print('Enter name of stack')
stack = input()
s3.upload_file('/home/lambda_test.py','vmadbro-lambda-code', 'lambda_test.py')
temp_url = 'https://cf-templates-13om8u1v5frdu-us-east-1.s3.amazonaws.com/20192260WX-Lambda27-9utis6opq8s'
cf.create_stack(StackName=stack, TemplateURL=temp_url)

r_url = "https://api.vmadbro.com/" + stack + "/"

print("API created at: " + r_url)

print('Enter first key value')
v1 = input()
print('Enter second key value')
v2 = input()

json_in = {
        "k1":v1,
        "k2":v2
}

test_num = 0

while True:
    r = requests.post(url = r_url, json=json_in, verify=False)
    test_num = test_num + 1
    if (r.status_code == 200):
        print("API result: " + r.text)
        print("Deleting stack: " + stack)
        cf.delete_stack(StackName=stack)
        break
    print(r.status_code)
    print("Attempt: " + str(test_num) + " Retrying attempt in 1s")
    time.sleep(1)
