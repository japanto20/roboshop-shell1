echo -e "\e[33mInstalling nginx\e[0m"
dnf install nginx -y
echo -e "\e[33mRemoving old content\e[0m"
rm -rf /usr/share/nginx/html/*
echo -e "\e[33mDownloading Frontend Content\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.
echo -e "\e[33mExtracting Downloaded Frontend\e[0m"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip
echo -e "\e[33mCopying nginx for Roboshop\e[0m"
pwd
ls -l
cp configs/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf
echo -e "\e[33mEnabling nginx\e[0m"
systemctl enable nginx
#systemctl restart nginx
echo -e "\e[33mStarting nginx\e[0m"
systemctl restart nginx


