# How to Use Terraform scripts
You should already have Terraform and AWS CLI installed.
If you haven't, following these links
[INSTALLING TERRAFORM](https://www.youtube.com/watch?v=LjRHJXwHN30)
[INSTALLING AWS CLI](https://www.youtube.com/watch?v=10C_t0g39uU)

1. Create an IAM User splunk_aws_user
2. Generate an Access Key
3. Add the access key to your Laptop in the file ```~/.aws/credentials```

```
[default]
aws_access_key_id=<replace>
aws_secret_access_key=<replacey>

```


# Splunk Infrastructure 
Update the following to get this to work for your currently environment

### variable.tf
Line 35, replace the Key pay with your Keypai.
Line 118, change the domain to your own domain.
If you don't have a domain use 
``` <your_first_name>.nilipay.com  ```

Line 141, to use Captivator Tailscale, change the tag name to your name
e.g ``` "tag:john" ```
Send your email and the tag you used to add you to the Access Control List (ACL)
If you have your own Tailscale, this step won't apply.

### route53.tf
Line 2, change the domain to your own domain.
If you don't have a domain use 
``` <your_first_name>.nilipay.com  ```

### main.tf
Line 3, change the bucket name to your own bucketname. Create one inside your AWS if you don't have one already.

Once the Infrastructure is deployed. 
Go to  ```Route 53 ==> Hosted Zones ==> <your_first_name>.nilipay.com ```, 
Copy the values of the NS (Name Server). It will be something like this:

```
ns-727.awsdns-26.net.
ns-1202.awsdns-22.org.
ns-1560.awsdns-03.co.uk.
ns-186.awsdns-23.com.
```

If you don't have your own domain, share this NS record with me to add the my domain.
If you have your own domain, go to your Domain Provider and add all these as a new Name Server

