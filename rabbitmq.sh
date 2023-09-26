source common.sh

roboshop_app_password=$1
if [ -z "${roboshop_app_password}" ]; then
  echo -e "\e[31mMissing rabbitmq app user Password argument\e[0m"
  exit 1
fi

print_head "Setup Erland repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>"${log_file}"
status_check $?

print_head "setup rabbitmq repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>"${log_file}"
status_check $?

print_head "Install rabbitmq server"
dnf install rabbitmq-server -y &>>"${log_file}"
status_check $?

print_head "Enable rabbitmq server"
systemctl enable rabbitmq-server &>>"${log_file}"
status_check $?

print_head "start rabbitmq server"
systemctl start rabbitmq-server &>>"${log_file}"
status_check $?

print_head "add user"
rabbitmqctl list_users | grep roboshop
if [ $? -ne 0 ]; then
  rabbitmqctl add_user roboshop "${roboshop_app_password}" &>>"${log_file}"
fi
status_check $?

print_head "set permission"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>"${log_file}"
status_check $?