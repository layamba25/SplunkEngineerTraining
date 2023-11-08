# Splunk Infrastructure 
Update the following to get this to work for your currently environment

### variable.tf
Line 118, change the domain to your own domain, if you don't have a domain use 
``` <your_first_name>.nilipay.com  ```

### route53.tf
Line 2, change the domain to your own domain, if you don't have a domain use 
``` <your_first_name>.nilipay.com  ```

### main.tf
Line 3, change the bucket name to your own bucketname. Create one inside your AWS if you don't have one.

Once the Infrastructure is deployed. 
Go to route 53 ==> Hosted Zones ==> <your_first_name>.nilipay.com, 
copy the values of the NS (Name Server). It will be something like this:

```
ns-727.awsdns-26.net.
ns-1202.awsdns-22.org.
ns-1560.awsdns-03.co.uk.
ns-186.awsdns-23.com.
```


If you don't have your domain, share this domain with me to add the my domain.
If you have your own domain, go to your Domain Provider and add all these as a new Name Server