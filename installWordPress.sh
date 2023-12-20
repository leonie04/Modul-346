#Schlüsselpaar und Sicherheitsgruppe erstellen
#Ports freischalten
#Instanzen starten
#Securitygroup anpassen
aws ec2 create-key-pair --key-name aws-wordpress-cli --key-type rsa --query 'KeyMaterial' --output text > ~/.ssh/aws-wordpress-cli.pem
echo create sec group
aws ec2 create-security-group --group-name wordpress-sec-group --description "EC2-WordPress-SG" | cat > secGroup.log
aws ec2 authorize-security-group-ingress --group-name wordpress-sec-group --protocol tcp --port 80 --cidr 0.0.0.0/0 | cat >> secGroup.log
aws ec2 authorize-security-group-ingress --group-name wordpress-sec-group --protocol tcp --port 443 --cidr 0.0.0.0/0 | cat >> secGroup.log
aws ec2 authorize-security-group-ingress --group-name wordpress-sec-group --protocol tcp --port 22 --cidr 0.0.0.0/0 | cat >> secGroup.log

echo start mysql instance
aws ec2 run-instances --image-id ami-0fc5d935ebf8bc3bc --count 1 --instance-type t2.micro --key-name aws-wordpress-cli --security-groups wordpress-sec-group --iam-instance-profile Name=LabInstanceProfile --user-data file://initialMySQL.txt --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=MySQL_oie2ds45turo}]' | cat > MySQLInstance.log

public_ip=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=MySQL_oie2ds45turo" --query "Reservations[*].Instances[*].{PublicIP: PublicIpAddress}" --output text | grep -v None)
sed -i "s/Soll_DB_Host_IP/$public_ip/" initialWordPress.txt
aws ec2 authorize-security-group-ingress --group-name wordpress-sec-group --protocol tcp --port 3306 --cidr $public_ip/0 | cat >> secGroup.log

echo start wordpress instance
aws ec2 run-instances --image-id ami-0fc5d935ebf8bc3bc --count 1 --instance-type t2.micro --key-name aws-wordpress-cli --security-groups wordpress-sec-group --iam-instance-profile Name=LabInstanceProfile --user-data file://initialWordPress.txt --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=WordPress}]' | cat > WordPressInstance.log
chmod 600 ~/.ssh/aws-wordpress-cli.pem

wp_ip=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=WordPress" --query "Reservations[*].Instances[*].{PublicIP: PublicIpAddress}" --output text | grep -v None)

# Reset changes to preserve the original 
sed -i "s/$public_ip/Soll_DB_Host_IP/" initialWordPress.txt

echo wordpress is soon avaiable on $wp_ip
