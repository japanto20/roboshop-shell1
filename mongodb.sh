source common.sh

print_head "Setup MongoDB repository"
# shellcheck disable=SC2154
# shellcheck disable=SC1009
cp "${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongo.repo &>>"${log_file}"

print_head "Install MongoDB"
dnf install mongodb-org -y &>>"${log_file}"

print_head "Update MongoDB listen address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>"${log_file}"

print_head "Enable MongoDB"
systemctl enable mongod &>>"${log_file}"

print_head "Start MongoDB Service"
# shellcheck disable=SC1073
# shellcheck disable=SC1073
# shellcheck disable=SC1073
systemctl restart mongod &>>"${log_file}"

# update /etc/mongod.conf file from 127.0.0.1 with 0.0.0.0
