import os

CWD = os.getcwd()
CWD_COUNT = len(CWD.split('/'))
TF_DIR_ITEMS = CWD.split('/')[0:CWD_COUNT - 2]
S = '/'
TF_DIR = S.join(TF_DIR_ITEMS)

os.system(TF_DIR + '/terraform init')

#AWS
print(TF_DIR + '/terraform plan '  + CWD + '/aws')
#os.system(tf_dir + '/terraform apply -var-file=' + aws_tf_var_file + ' ' + cwd)

#GCP
#os.system(tf_dir + '/terraform plan -var-file=' + gcp_tf_var_file + ' ' + cwd)
#os.system(tf_dir + '/terraform apply -var-file=' + aws_tf_var_file + ' ' + cwd)