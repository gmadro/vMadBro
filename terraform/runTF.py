import os

cwd = os.getcwd()
cwd_count = len(cwd.split('/'))
tf_dir_items = cwd.split('/')[0:cwd_count - 2]
s = '/'
tf_dir = s.join(tf_dir_items)

print(tf_dir)
