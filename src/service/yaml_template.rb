# frozen_string_literal: true
require_relative '../util/file_util'

SC_TEMPLATE = "--- !ruby/object:Schedule
#需要调度的命令
command: touch /tmp/test
#corn表达式
corn: \"* * * * * *\"
#是否只执行一次
once: false
#是否仅是本地执行
is_local: false
targets:
- !ruby/object:Target
  #第一台目标机器地址
  ip: 127.0.0.1
  #用户名
  username: test
  #密码
  password: '123456'
- !ruby/object:Target
  #目标调度机器地址  不写用户密码则要求该地址与当前执行脚本的机器能够进行ssh
  ip: 128.0.0.2
#需要调度的文件
exec_file: \"/tmp/test.sh\"
"

SSH_TEMPLATE = "--- !ruby/object:SSH
#源ip地址 操作将从该地址发起 可选参数 默认为127.0.0.1
master: 127.0.0.1
#源ip地址的网卡名称 可选参数
network_name:
#联合用户名密码
unite_username: root
#联合用户密码
unite_password: '123456'
# ssh操作是否是相互进行
each_other: true
targets:
- !ruby/object:Target
  #目标ip
  ip: 127.0.0.1
  #目标机器的用户名 不写默认取联合用户名
  username: ''
  #目标机器的密码 不写默认取联合密码
  password: ''
- !ruby/object:Target
  #第二台机器信息 同上
  ip: 128.0.0.2
  username: ''
  password: ''
"

def writer_obj(op, src_file)
  case op
  when "ssh"
    writer_ssh(src_file)
  when "sc"
    writer_sc(src_file)
  else
    exit 0
  end

end

def writer_sc(src_file)
  file_write(SC_TEMPLATE, src_file)
end

def writer_ssh(src_file)
  file_write(SSH_TEMPLATE, src_file)
end
