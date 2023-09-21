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
id roboshop &>>"${log_file}"
if [ $? -ne 0 ]; then
 useradd roboshop &>>"${log_file}"
fi
status_check $?

print_head "Create app directory"
if [ ! -d /app ]; then
  mkdir /app &>>"${log_file}"
fi
status_check $?

print_head "Delete old content"
rm -rf /app/* &>>"${log_file}"
status_check $?

print_head "Downloading app content"
curl -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip &>>"${log_file}"
status_check $?
cd /app

print_head "Extracting app content"
unzip /tmp/user.zip &>>"${log_file}"
status_check $?

print_head "IInstall Nodejs dependencies"
npm install &>>"${log_file}"
status_check $?

print_head "Copy systemD service file"
# shellcheck disable=SC2154
cp "${code_dir}"/configs/user.service /etc/systemd/system/user.service &>>"${log_file}"
status_check $?

print_head "Reload systemD"
systemctl daemon-reload &>>"${log_file}"
status_check $?

print_head "Enable user service"
systemctl enable user &>>"${log_file}"
status_check $?

print_head "Start user service"
systemctl start user &>>"${log_file}"
status_check $?

print_head "Copy MongoDb file"
cp "${code_dir}"/configs/mongodb.repo /etc/yum.repos.d/mongo.repo &>>"${log_file}"
status_check $?
dnf install mongodb-org-shell -y &>>"${log_file}"
status_check $?

print_head "Load Schema"
mongo --host mongodb.antodevops20.online </app/schema/user.js &>>"${log_file}"
status_check $?