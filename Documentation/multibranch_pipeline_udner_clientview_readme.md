### MULTIBRANCH PIPELINES UNDER CLIENT VIEW 
In the view it creates a multi-branch pipeline of the `client_config` and `clients jenkins repository`

![](https://gitlab.cloudifyops.com/devoptymize/documentation/-/raw/main/images/8.png)


 `Clientabc_config_multibranch`:  The multi-branch pipeline of the client_config repository. This includes loading and triggering of the configuration pipelines . The pipelines are 

- Create_AWS_creds - This pipeline is to create the AWS credentials in jenkins credentials manager for the client which will be AWS account specific . The naming convention format for the AWS creds is `<client_name>_<account_id>_aws_cred`.

- Create_s3_DynamoDB :  this pipeline is to create an S3 for storing terraform state file and dynamoDB for maintaining the lock for the client.



`Clientabc_resource_multibranch` :   the multi-branch pipeline of the client_jenkins repository. This includes loading and triggering the resources pipeline.

![](https://gitlab.cloudifyops.com/devoptymize/documentation/-/raw/main/images/9.png)
