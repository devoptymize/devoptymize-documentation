### CREATE S3_DYNAMODB PIPELINE

### Create new jenkins user <clientname> and login from that user. 

- Add iteam roles under `manage and assign roles` assign `item roles` 
- Mention the client name in iteam roles and the following permissions
- Under `assign roles` mention `client name` and add to user/group

![](https://gitlab.cloudifyops.com/devoptymize/documentation/-/raw/main/images/17.png)

Execute `Create_s3_DynamoDB` pipeline fromt the `<clientname>_config_multibranch`

![](https://gitlab.cloudifyops.com/devoptymize/documentation/-/raw/main/images/12.png)

In the parameters credentials will list out for specific client and pass the env name and start the build . this pipeline is to create an S3 for storing terraform state file and dynamoDB for maintaining the lock for the client .  
