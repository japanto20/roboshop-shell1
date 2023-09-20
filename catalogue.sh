source common.sh

print_head "Configure NodeJS repo"
sudo yum install https://rpm.nodesource.com/pub_20.x/nodistro/repo/nodesource-release-nodistro-1.noarch.rpm -y  &>>"${log_file}"
sudo yum install nodejs -y --setopt=nodesource-nodejs.module_hotfixes=1 &>>"${log_file}"

print_head "Install NodeJS"
dnf install nodejs -y &>>"${log_file}"

print_head "Create Roboshop user"
useradd roboshop &>>"${log_file}"

print_head "Create app directory"
mkdir /app &>>"${log_file}"

print_head "Delete old content"
rm -rf /app/* &>>"${log_file}"

print_head "Downloading app content"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>"${log_file}"
cd /app

print_head "Extracting app content"
unzip /tmp/catalogue.zip &>>"${log_file}"

print_head "IInstall Nodejs dependencies"
npm install &>>"${log_file}"

print_head "Copy systemD service file"
cp configs/catalogue.service /etc/systemd/system/catalogue.service &>>"${log_file}"

print_head "Reload systemD"
systemctl daemon-reload &>>"${log_file}"

print_head "Enable Catalogue service"
systemctl enable catalogue &>>"${log_file}"

print_head "Start catalogue service"
systemctl start catalogue &>>"${log_file}"

print_head "Copy MongoDb file"
cp configs/mongodb.repo /etc/yum.repos.d/mongo.repo &>>"${log_file}"
dnf install mongodb-org-shell -y &>>"${log_file}"

print_head "Load Schema"
mongo --host mongodb.antodevops20.online </app/schema/catalogue.js &>>"${log_file}"
