#Schlüsselpaar und Sicherheitsgruppe erstellen
#Ports freischalten
#Instanzen starten
#Securitygroup anpassen
aws ec2 create-key-pair --key-name aws-wordpress-cli --key-type rsa --query 'KeyMaterial' --output text > ~/.ssh/aws-wordpress-cli.pem
aws ec2 create-security-group --group-name wordpress-sec-group --description "EC2-WordPress-SG"
aws ec2 authorize-security-group-ingress --group-name wordpress-sec-group --protocol tcp --port 80 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-name wordpress-sec-group --protocol tcp --port 443 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-name wordpress-sec-group --protocol tcp --port 22 --cidr 0.0.0.0/0

aws ec2 run-instances --image-id ami-0fc5d935ebf8bc3bc --count 1 --instance-type t2.micro --key-name aws-wordpress-cli --security-groups wordpress-sec-group --iam-instance-profile Name=LabInstanceProfile --user-data file://initialMySQL.txt --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=MySQL}]' --no-paginate
aws ec2 run-instances --image-id ami-0fc5d935ebf8bc3bc --count 1 --instance-type t2.micro --key-name aws-wordpress-cli --security-groups wordpress-sec-group --iam-instance-profile Name=LabInstanceProfile --user-data file://initialWordPress.txt --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=WordPress}]' --no-paginate
chmod 600 ~/.ssh/aws-wordpress-cli.pem

public_ip=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=mysql" --query "Reservations[*].Instances[*].{PublicIP: PublicIpAddress}" --output json | jq -r '.[][].PublicIP')
aws ec2 authorize-security-group-ingress --group-name launch-wizard-5 --protocol tcp --port 22 --cidr $public_ip/32


