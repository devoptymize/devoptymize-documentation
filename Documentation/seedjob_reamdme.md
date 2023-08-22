## SEED Job 

The  Seed job creates a view that will be client specific. A multi-branch pipeline of the  respective repository which includes loading the pipelines ,creating AWS credentials in Jenkins credential manage, and creating the S3 & DynamoDB to store the Terraform state files and manage the Terraform lock respectively.

It creates another multibranch pipeline of the respective repository which includes loading of all the resource pipelines which will be client-specific.

This seed job will be `freestyle project` in jenkins .


- Create  `freestyle project` in jenkins .
- In the `configure` section  add string parameter `CLIENT_NAME`

![](https://gitlab.cloudifyops.com/devoptymize/documentation/-/raw/main/images/3.png)

- Under the `source code management` mention client gitlab url of `DevOptymize_jenkins_shared_libraries` and mention the branch .

![](https://gitlab.cloudifyops.com/devoptymize/documentation/-/raw/main/4.png)


- Build steps - under build steps mention specific path for your code for example `(jobs/*.groovy)` save and run the job .


- Click on `build with parameters` , mention the `CLIENT_NAME`  and start the build . After execution of the job , there will be client specific view.

![](https://gitlab.cloudifyops.com/devoptymize/documentation/-/raw/main/images/5.png)
