import os
def main():
    os.system('terraform apply -var "app_name=terrapy01" -auto-approve')
main()