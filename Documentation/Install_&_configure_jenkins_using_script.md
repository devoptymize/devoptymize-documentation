## Install and configure Jenkins

To install and set up a new jenkins, you may excute the [jenkins_build.sh](/Documentation/scripts/jenkins_build.sh) on Amazon Linux 2023 

The script would install jenkins and install the required plugins for us. It wouild install the below perequisites as well

- Terraform
- Python - 3.8.10
- JQ
- Jinja2 - 2.10.1
- pyyaml - 5.3.1

If you wish to follow manual steps to install please follow the instruction given in the [link](/Documentation/Install_&_configure_jenkins_manually.md)

### To integrate jenkins with AWS account: 

- SSH to the jenkins box
- Swtich as `jenkins user` 
- run `aws configure` as `jenkins user`, add `aws access key id` and `secret key`

![](https://gitlab.cloudifyops.com/devoptymize/documentation/-/raw/main/images/Screenshot_2023-07-05_124832.png)