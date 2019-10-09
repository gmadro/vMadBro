import os

aws_tf_plan = 'lambda.tf'
aws_tf_var_file = 'lambda.tfvars.json'
gcp_tf_var_file = 'cloudFunctions.tfvars.json'

cwd = os.getcwd()
cwd_count = len(cwd.split('/'))
tf_dir_items = cwd.split('/')[0:cwd_count - 2]
s = '/'
tf_dir = s.join(tf_dir_items)

os.system(tf_dir + '/terraform init')
#AWS
os.system(tf_dir + '/terraform plan -var-file=' + aws_tf_var_file + ' ' + cwd)
os.system(tf_dir + '/terraform apply -var-file=' + aws_tf_var_file + ' ' + cwd)
#GCP
os.system(tf_dir + '/terraform plan -var-file=' + gcp_tf_var_file + ' ' + cwd)
#os.system(tf_dir + '/terraform apply -var-file=' + aws_tf_var_file + ' ' + cwd)