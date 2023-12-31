source common.sh

print_head "Installing nginx"
dnf install nginx -y &>>${log_file}
status_check $?

print_head "Removing old content"
rm -rf /usr/share/nginx/html/* &>>${log_file}
status_check $?

print_head "Downloading Frontend Content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log_file}
status_check $?

print_head "Extracting Downloaded Frontend"
# shellcheck disable=SC2164
cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>>${log_file}
status_check $?

print_head "Copying nginx for roboshop"
cp "${code_dir}"/configs/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${log_file}
status_check $?

print_head "Enabling nginx"
systemctl enable nginx &>>${log_file}
status_check $?

#systemctl restart nginx
print_head "Starting nginx"
systemctl restart nginx &>>${log_file}
status_check $?

