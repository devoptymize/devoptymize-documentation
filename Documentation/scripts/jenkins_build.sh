#!/bin/bash

# Function to check if a package is installed
check_package_installed() {
    package_name=$1
    if yum list installed "$package_name" >/dev/null 2>&1; then
        echo "$package_name is already installed."
    else
        echo "Installing $package_name..."
        sudo yum install -y "$package_name"
        if yum list installed "$package_name" >/dev/null 2>&1; then
            echo "$package_name is installed successfully."
        else
            echo "Failed to install $package_name."
            exit 1
        fi
    fi
}


# Function to check the status of a service
check_service_status() {
    service_name=$1
    if sudo systemctl is-active --quiet $service_name; then
        echo "$service_name is running."
    else
        echo "Failed to start $service_name."
        exit 1
    fi
}

# Function to install Certbot Nginx plugin if not already installed
install_certbot_nginx_plugin() {
    if ! command -v certbot &> /dev/null; then
        echo "Installing Certbot..."
        sudo yum install certbot -y &> /dev/null
        sudo yum -y install python-certbot-nginx &> /dev/null
    fi
}
# Function to wait for Jenkins to be ready before creating credentials
wait_for_jenkins_ready() {
    local max_attempts=30
    local attempt=0
    while [ $attempt -lt $max_attempts ]; do
        if java -jar jenkins-cli.jar -s http://localhost:8080/ -auth admin:"$jenkins_password" help &> /dev/null; then
            return 0
        fi
        sleep 5
        ((attempt++))
    done
    return 1
}
# Function to create Jenkins credentials in username/password format
create_jenkins_credentials() {
    local username="$1"
    local password="$2"

    echo "Creating Jenkins credentials for $username..."

    credentials_xml="<com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl>
        <scope>GLOBAL</scope>
        <id>devoptymize_git_credential</id>
        <description>Devoptymize git credential</description>
        <username>$username</username>
        <password>$password</password>
    </com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl>"

    # Use echo and pipe to pass the XML content as input to the command
    echo "$credentials_xml" | java -jar jenkins-cli.jar -s http://localhost:8080/ -auth admin:"$jenkins_password" create-credentials-by-xml "system::system::jenkins" "(global)"

    if [ $? -eq 0 ]; then
        echo "Jenkins credentials for $username created successfully."
    else
        echo "Failed to create Jenkins credentials for $username."
    fi
}

#  Enable and start Nginx
install_nginx() {
    if ! command -v nginx &> /dev/null; then
        echo "Installing Nginx..."
        sudo amazon-linux-extras install nginx1.12 -y
        sudo systemctl start nginx
        sudo systemctl enable nginx
        sudo systemctl status nginx
    fi
}

# Function to configure Nginx as a reverse proxy for Jenkins
configure_nginx_for_jenkins() {
    local domain="$1"
    local nginx_conf="/etc/nginx/conf.d/${domain}.conf"

    # Remove old Nginx configuration if it exists
    if [ -f "$nginx_conf" ]; then
        sudo rm "$nginx_conf"
    fi

    # Add new Nginx configuration for Jenkins reverse proxy
    echo "Configuring Nginx as a reverse proxy for Jenkins at $domain..."
    cat > "$nginx_conf" <<EOT
    server {
        listen 80;
        server_name $domain;

        location / {
            proxy_pass http://localhost:8080;
            proxy_set_header Host \$host;
            proxy_set_header X-Real-IP \$remote_addr;
            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto \$scheme;
        }
    }
EOT
    sudo nginx -t && sudo systemctl restart nginx
}

# Function to obtain an SSL certificate from Let's Encrypt using Certbot
get_ssl_certificate() {
    local domain="$1"
    local email="$2"

    echo "Obtaining SSL certificate from Let's Encrypt..."
    sudo certbot --nginx -d "$domain" -m "$email" --agree-tos --no-eff-email --redirect
}

setup_auto_renewal() {
    echo "Setting up automatic certificate renewal..."
    # Check if the cron job already exists
    if crontab -l | grep -q '/usr/bin/certbot renew --quiet --post-hook'; then
        echo "Automatic certificate renewal cron job already exists."
    else
        # Add a cron job to renew the certificate twice a day
        (sudo crontab -l 2>/dev/null; echo "0 0,12 * * * /usr/bin/certbot renew --quiet --post-hook 'systemctl restart nginx'") | sudo crontab -
        echo "Automatic certificate renewal cron job added."
    fi
}

# Check if the script is run as root or with sudo
if [ "$EUID" -ne 0 ]; then
    echo "Please run the script as root or with sudo."
    exit 1
fi

#  Read domain name, new Git URL, and new credentials ID
read -p "Enter your Jenkins domain (e.g., jenkins.example.com): " domain
read -p "Enter your email address for Let's Encrypt notifications: " email

echo "Creating Jenkins credentials..."
read -p "Enter new Git URL: " new_git_url
read -p "Enter username: " jenkins_username
read -s -p "Enter password: " jenkins_password
echo

# Update Git URL and credentials ID in the XML file
xml_file="job_config.xml"
sed -i "s|<url>.*</url>|<url>${new_git_url}</url>|" "$xml_file"
url_replaced=$?
# sed -i "s|<credentialsId>.*</credentialsId>|<credentialsId>${new_credentials_id}</credentialsId>|" "$xml_file"
# credentials_replaced=$?

if [ $url_replaced -eq 0 ] ; then
    echo "Git URL replaced successfully."
else
    echo "Failed to replace Git URL."
fi

# Disable Corretto repository temporarily
sudo yum-config-manager --disable corretto

#  Install EPEL repository
sudo amazon-linux-extras install epel -y

#  Re-enable repository priority protections
#sudo yum-config-manager --enable-priorities

# Install Java 11 using default repositories
sudo amazon-linux-extras install java-openjdk11 -y &> /dev/null
check_package_installed "java-11-openjdk"

# Install Jenkins
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo tee /etc/yum.repos.d/jenkins.repo <<EOF
[jenkins]
name=Jenkins
baseurl=https://pkg.jenkins.io/redhat-stable
gpgcheck=0
EOF
check_package_installed "jenkins-2.401.2-1.1"

#  Start and enable Jenkins service
sudo systemctl restart jenkins
sudo systemctl enable jenkins
check_service_status "jenkins"
sleep 5

#  Download Jenkins CLI
wget -q "http://localhost:8080/jnlpJars/jenkins-cli.jar" -O jenkins-cli.jar
jenkins_password=$(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)

create_jenkins_credentials "$jenkins_username" "$jenkins_password"

# Install Jenkins plugins
plugins=("aws-secrets-manager-credentials-provider:1.202.ve0ec0c17611c" "aws-global-configuration:108.v47b_fd43dfec6" "build-name-setter:2.2.1" "description-setter:1.10"  "extended-choice-parameter:373.v1a_ecea_fdf2a_a_" "extensible-choice-parameter:1.8.0" "mask-passwords:150.vf80d33113e80" "parameter-separator:87.va_1816d0b_39d1" "parameterized-trigger:2.45" "workflow-aggregator:596.v8c21c963d92d" "pipeline-utility-steps:2.15.4" "pipeline-aws:1.43" "pipeline-groovy-lib:656.va_a_ceeb_6ffb_f7" "pipeline-github-lib:42.v0739460cda_c4" "project-description-setter:1.2" "ws-cleanup:0.45" "role-strategy:633.v836e5b_3e80a_5")

for plugin in "${plugins[@]}"; do
    plugin_name=$(echo "$plugin" | cut -d ':' -f 1)
    version=$(echo "$plugin" | cut -d ':' -f 2)
    java -jar jenkins-cli.jar -s http://localhost:8080/ -auth admin:"$jenkins_password" install-plugin "$plugin_name:$version"
done

# Create Jenkins job
if java -jar jenkins-cli.jar -s http://localhost:8080/ -auth admin:"$jenkins_password" get-job "DevOptymize_Seedjob" >/dev/null 2>&1; then
    echo "Jenkins job 'DevOptymize_Seedjob' already exists."
else
    echo "Creating Jenkins job 'DevOptymize_Seedjob'..."
    java -jar jenkins-cli.jar -s http://localhost:8080/ -auth admin:"$jenkins_password" create-job DevOptymize_Seedjob < "$xml_file"
    job_creation_status=$?

    if [ $job_creation_status -eq 0 ]; then
        echo "Jenkins job 'DevOptymize_Seedjob' created successfully."
    else
        echo "Failed to create Jenkins job 'DevOptymize_Seedjob'."
        exit 1
    fi
fi
#  Restart Jenkins service
sudo systemctl restart jenkins
check_service_status "jenkins"

# Cleanup
rm -f jenkins-cli.jar

#  Set the login shell for the Jenkins user to /bin/bash
usermod --shell /bin/bash jenkins

#  Check if the shell modification was successful
if [ $? -ne 0 ]; then
    echo "Failed to change the login shell for the Jenkins user."
    exit 1
fi

echo "Login shell for the Jenkins user has been changed to /bin/bash."

#  Configure sudo access for the Jenkins user
echo "jenkins ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers.d/jenkins >/dev/null

# Install required packages for Jenkins operations
check_package_installed "jq"
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo

check_package_installed "terraform"
check_package_installed "python3-jinja2" &> /dev/null
check_package_installed "python3-pip" &> /dev/null
sudo pip3 install pyyaml==5.3.1 &> /dev/null

# Main script execution
install_nginx &> /dev/null
install_certbot_nginx_plugin &> /dev/null
configure_nginx_for_jenkins "$domain"
get_ssl_certificate "$domain" "$email"
setup_auto_renewal

echo "Jenkins with Nginx reverse proxy and Let's Encrypt SSL certificate successfully set up for $domain!"
