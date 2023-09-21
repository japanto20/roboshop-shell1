source common.sh

print_head "Configure NodeJS repo"
sudo yum install https://rpm.nodesource.com/pub_20.x/nodistro/repo/nodesource-release-nodistro-1.noarch.rpm -y  &>>"${log_file}"
status_check $?
sudo yum install nodejs -y --setopt=nodesource-nodejs.module_hotfixes=1 &>>"${log_file}"
status_check $?

print_head "Install NodeJS"
dnf install nodejs -y &>>"${log_file}"
status_check $?

print_head "Create Roboshop user"
id roboshop "${log_file}"
if [ $? -ne 0 ]; then
  useradd roboshop &>>"${log_file}"
fi
status_check $?

print_head "Create app directory"
mkdir /app &>>"${log_file}"
status_check $?

print_head "Delete old content"
rm -rf /app/* &>>"${log_file}"
status_check $?

print_head "Downloading app content"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>"${log_file}"
status_check $?
cd /app

print_head "Extracting app content"
unzip /tmp/catalogue.zip &>>"${log_file}"
status_check $?

print_head "IInstall Nodejs dependencies"
npm install &>>"${log_file}"
status_check $?

print_head "Copy systemD service file"
# shellcheck disable=SC2154
cp "${code_dir}"/configs/catalogue.service /etc/systemd/system/catalogue.service &>>"${log_file}"
status_check $?

print_head "Reload systemD"
systemctl daemon-reload &>>"${log_file}"
status_check $?

print_head "Enable Catalogue service"
systemctl enable catalogue &>>"${log_file}"
status_check $?

print_head "Start catalogue service"
systemctl start catalogue &>>"${log_file}"
status_check $?

print_head "Copy MongoDb file"
cp "${code_dir}"/configs/mongodb.repo /etc/yum.repos.d/mongo.repo &>>"${log_file}"
status_check $?
dnf install mongodb-org-shell -y &>>"${log_file}"
status_check $?

print_head "Load Schema"
mongo --host mongodb.antodevops20.online </app/schema/catalogue.js &>>"${log_file}"
status_check $?