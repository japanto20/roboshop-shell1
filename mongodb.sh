source common.sh

print_head "Setup MongoDB repository"
cp "{code_dir}"configs/mongodb.repo /etc/yum.repos.d/mongo.repo

print_head "Install MongoDB"
dnf install mongodb-org -y

print_head "Enable MongoDB"
systemctl enable mongod

print_head "Start MongoDB Service"
systemctl start mongod

# update /etc/mongod.conf file from 127.0.0.1 with 0.0.0.0
