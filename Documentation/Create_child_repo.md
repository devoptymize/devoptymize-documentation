## Create  repo group 

Create new repos with the below names based on the IaC Tools selected. These are to be blank repo as of now. 

   1. DevOptymize_CloudFormation
   2. DevOptymize_Terraform

Ensure to add the .gitignore as explained [below](#git-ignore)
   
Fork  the below repos to your account. 

   1. [DevOptymize_Jenkins_Pipelines]()
   2. [DevOptymize_Jenkins_Shared_Libraries]()
   3. [DevOptymize_Jenkins_Config]()


### Git Ignore file {#git-ignore}

Content of the .gitignore file 

``` # Local .terraform directories
**/.terraform/*

# .tfstate files
*.tfstate
*.tfstate.*

# Crash log files
crash.log

# Ignore any .tfvars files that are generated automatically for each Terraform run. Most
# .tfvars files are managed as part of configuration and so should be included in
# version control.
#
# example.tfvars

# Ignore override files as they are usually used to override resources locally and so
# are not checked in
override.tf
override.tf.json
*_override.tf
*_override.tf.json

# Include override files you do wish to add to version control using negated pattern
#
# !example_override.tf

tfplan
tfplan.txt
tfdestroy
tfdestroy.txt
**.pem 
```