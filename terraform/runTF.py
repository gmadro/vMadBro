import os

tf_plan = 'lambda.tf'
#tf_function_name = "-var 'function_name=TFpyFunction'"

cwd = os.getcwd()
cwd_count = len(cwd.split('/'))
tf_dir_items = cwd.split('/')[0:cwd_count - 2]
s = '/'
tf_dir = s.join(tf_dir_items)

os.system(tf_dir + '/terraform init')
#print(tf_dir + '/terraform plan ' + tf_function_name + ' ' + cwd)
os.system(tf_dir + '/terraform plan ' + cwd)
#os.system(tf_dir + '/terraform apply' + tf_plan)
