code_dir=$(pwd)
log_file=/tmp/roboshop.log
rm -rf${log_file}

echo -e "\e[33mInstalling nginx\e[0m"
dnf install nginx -y &>>${log_file}

echo -e "\e[33mRemoving old content\e[0m"
rm -rf /usr/share/nginx/html/* &>>${log_file}

echo -e "\e[33mDownloading Frontend Content\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log_file}

echo -e "\e[33mExtracting Downloaded Frontend\e[0m"
# shellcheck disable=SC2164
cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>>${log_file}

echo -e "\e[33mCopying nginx for Roboshop\e[0m"
cp "${code_dir}"/configs/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${log_file}

echo -e "\e[33mEnabling nginx\e[0m"
systemctl enable nginx &>>${log_file}

#systemctl restart nginx
echo -e "\e[33mStarting nginx\e[0m"
systemctl restart nginx &>>${log_file}


