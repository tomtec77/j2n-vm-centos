#!/bin/bash

sudo yum update
sudo yum install -y git subversion vim wget

sudo useradd -u 10001 -d /home/ruser ruser
echo 'ruser:globant' | sudo chpasswd

sudo yum install -y epel-release
sudo yum install -y texlive
sudo yum install -y R

curl -O https://download2.rstudio.org/rstudio-server-rhel-1.0.136-x86_64.rpm
sudo yum install -y --nogpgcheck rstudio-server-rhel-1.0.136-x86_64.rpm
rm rstudio-server-rhel*

sudo mkdir -p /home/ruser/R/x86_64-redhat-linux-gnu-library/3.3
sudo chown -R ruser:ruser /home/ruser/R/

cat <<EOT >> /home/vagrant/install-packages.R
packages.list <- c("tidyverse", "fpp", "xts", "XLConnect", "imputeTS",
                   "reshape2", "plumber", "jsonlite")
install.dir <- "/home/ruser/R/x86_64-redhat-linux-gnu-library/3.3"

install.packages(packages.list, install.dir, repos="http://cran.rstudio.com")
EOT

sudo yum install -y libxml2-devel libcurl-devel openssl-devel

echo "Installing R packages..."
sudo Rscript install-packages.R

sudo chown -R ruser:ruser /home/ruser/R/

echo "Provisioning complete."
