#### TEMPLATE DESCRIPTION ####

This template will launch an EC2 Windows instance in your required subnet and VPC and Create a LoadBalancer and TargetGroup having the launched instance behind.


First you should create IAM user having EC2FullAccess Policy attached.

A Security group with ports 3389, 80, and 443 will be created.

Then an Application LoadBalancer will be Created having a HTTPS Listener at port 443 and you will be asked to enter the ARN of the certificate.
(You should have a certificate on your amazon certificate manager)

A TargetGroup will be created and the created instance will be registered to that target group, and the health check will be at port 80.

After the template is successfully run you will get the ALB's DNS name and Instance's public IP as outputs.

#### HOW TO USE ####

1. Run the template using:
$ terraform apply

2. Enter the variables required:
Each variable has a description

3. The IP address of the instance and the DNS name of the LoadBalancer will be presented as outputs.

4.Test the functionality by entering either the IP Address of the instance or the DNS name of the LoadBalancer in your browser.

5. Cleanup using:
$ terraform destroy

#### NOTES ####

1. The subnet you choose should be in the same Availability zone you choose.
2. The Windows instance will be launched with a key that is already existed in the account, so the Key Pair variable is case sensitive.
3. The subnets should be public subnets.