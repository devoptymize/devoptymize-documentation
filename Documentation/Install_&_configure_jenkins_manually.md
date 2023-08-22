## Install and configure Jenkins

Prerequisites to be installed on jenkins server (as of now, these are the vesions we have tested)

- Terraform
- Python - 3.8.10
- JQ
- Jinja2 - 2.10.1
- pyyaml - 5.3.1

#### Install Jenkins on AWS EC2

- `sudo yum  update `
- Add the Jenkins repo using the following command:
  
  `sudo wget -O /etc/yum.repos.d/jenkins.repo \ https://pkg.jenkins.io/redhat-stable/jenkins.repo `
- Import a key file from Jenkins-CI to enable installation from the package:

  `sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key`
- Install Java (Amazon Linux 2):

  `sudo amazon-linux-extras install java-openjdk11 -y`

- Install Jenkins:

  `sudo yum install jenkins -y`
- Enable the Jenkins service to start at boot:
   
  `sudo systemctl enable jenkins`
- Start Jenkins as a service:

  `sudo systemctl start jenkins`

[REFERENCE LINK](https://www.jenkins.io/doc/tutorials/tutorial-for-installing-jenkins-on-AWS/#:~:text=Jenkins%20is%20an%20open-source%20automation%20server%20that%20integrates,through%20the%20process%20of%20deploying%20a%20Jenkins%20application.) 

[For other linux distributions](https://www.jenkins.io/doc/book/installing/linux/) 


### Install below plugins on jenkins 

- [AWS global configuration](https://plugins.jenkins.io/aws-global-configuration/)
- [AWS secret manager credentials provider](https://plugins.jenkins.io/aws-secrets-manager-credentials-provider/)
- [Build name setter plugin for jenkins](https://plugins.jenkins.io/build-name-setter/)
- [Description setter](https://plugins.jenkins.io/description-setter/)
- [Dynamic extended choice parameter](https://plugins.jenkins.io/dynamic_extended_choice_parameter/)
- [Extended choice parameter](https://plugins.jenkins.io/extended-choice-parameter/)
- [Extensible choice parameter](https://plugins.jenkins.io/extensible-choice-parameter/)- [Job DSL](https://plugins.jenkins.io/job-dsl/)
- [LDAP plugin](https://plugins.jenkins.io/ldap/)
- [Mask passwords plugin](https://plugins.jenkins.io/mask-passwords/)
- [Parameter separator plugin ](https://plugins.jenkins.io/parameter-separator/)
- [Parameterized trigger](https://plugins.jenkins.io/parameterized-trigger/)
- [Pipeline](https://plugins.jenkins.io/workflow-aggregator/)
- [Pipeline utility steps](https://plugins.jenkins.io/pipeline-utility-steps/)
- [Pipeline : AWS steps](https://plugins.jenkins.io/pipeline-aws/)
- [Pipeline : groovy libraries](https://plugins.jenkins.io/pipeline-groovy-lib/)
- [Pipeline : github groovy libraries](https://plugins.jenkins.io/pipeline-github-lib/)
- [Project description setter](https://plugins.jenkins.io/project-description-setter/)
- [Workspace cleaner plugin](https://plugins.jenkins.io/ws-cleanup/)
- [Role-based authorization strategy](https://plugins.jenkins.io/role-strategy/)

### To integrate jenkins with AWS account: 

- Swtich as `jenkins user` 
- run `aws configur` as `jenkins user`, add `aws access key id`
  and `secret key`

![](https://gitlab.cloudifyops.com/devoptymize/documentation/-/raw/main/images/Screenshot_2023-07-05_124832.png)

### To execute commands on jenkins server without any password 
- Edit `visudo` 
- add `jenkins ALL=(ALL) NOPASSWD: ALL`

  This will allow jenkins user to execute command without any password 



### CREATE CLIENT REPO GROUP

The pipeline is to create a gitlab or github group for a client , which contains the projects for terraform , cloudformation and jenkins config files .
To create client repo group , [click here](https://gitlab.cloudifyops.com/devoptymize/documentation/-/blob/main/Readme%20files/create_client_repo_group_readme.md)

### INSTALLING AND CONFIGURING DEVOPTYMIZE JENKINS SERVER

To installing and configuring devoptymize jenkins server [click here](https://gitlab.cloudifyops.com/devoptymize/documentation/-/blob/main/Readme%20files/Install_and_configure_jenkins_serverReadme.md) 



### PREREQUISITE INSTALLATIONS ON JENKINS SERVER

Prerequisite installations are mandatory on jenkins server . To install prerequisite , [click here](https://gitlab.cloudifyops.com/devoptymize/documentation/-/blob/main/Readme%20files/Prerequisite_installations_on_jenkins_server.readme.md)



## MANAGE JENKINS

Manage Jenkins is a section in the Jenkins user interface (UI) that provides access to various administrative and configuration options for the Jenkins system.

- Configure system
- Manage plugins
- Global tool configurations


to configure jenkins , [click here](https://gitlab.cloudifyops.com/devoptymize/documentation/-/blob/main/Readme%20files/manage_jenkins_readme.md)