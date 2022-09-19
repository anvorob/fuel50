# fuel50
Infrastructure:
IP address to access web site 52.65.82.83
Web page is deployed using EC2 instance and html/css files created as part of cloud-init process.
The better way would be to upload files via file provisioner but there was an issue locating destination directory which i think is linked to user home dir.

Another ways to deploy bigger web application would be to use ECS and Fargate, however I dont have experience deploying that.
Alternatively EKS could be used aswell. Docker image is required for that and should be upload to ECR.


Top 5 things to do to harden a Linux AMI from AWS.
1. Limit port access - only allow inbound traffic on limited ports like 22 for SSH or 80/443 HTTP/HTTPS
2. Securing login - use sudo passwd -l root to lock access to the root account via password. Instead, use SSH key pair access. This prevents risk of brute force or phishing attacks. To further harden access, this policy can be applied to all users.
3. Limiting a number of users - allow only a limited number of users and remove default OS users.
4. Encrypt data storage.
5. Install security updates and reduce the number of applications used in OS to essential to reduce the possibility of vulnerability introduced in the new upgrade.

Top 3 security risks to Fuel50’s infrastructure and product at this point
in time. 
(NOTE: I am not completely familiar with the existing infrastructure set up)
1. DDoS attack has proven to interfere with application operation and impacts user access to the system. AWS Shield standard or advanced - enables protection against DDoS attacks.
2. Vulnerability exploration with malicious intent is performed by hackers to find ways into the system. AWS WAF allows implementing different firewall rules to screen incoming requests for malicious actions by bots and hackers. Those rules can be specific to OS or applications.
3. Unencrypted data transfer can be leaked and used with malicious intent. Hence, by implementing TLS/SSL certificates for web server Fuel50 can assure users that their credentials and personal information is secure. Furthermore, generating these certificates in Amazon Certificate Manager, allows to rotate these certificates.
