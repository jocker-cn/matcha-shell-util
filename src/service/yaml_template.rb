# frozen_string_literal: true
require_relative '../util/file_util'
require_relative '../util/logger_util'

SC_TEMPLATE = "--- !ruby/object:Schedule
#全局用户名 targets中未指定用户名将使用此用户名
unit_username: root
#全局用户密码 targets中未指定用户密码将使用此密码
unit_password: '123456'
tasks:
- !ruby/object:Task
  #任务类型  copy 表示文件复制  command 表示执行命令
  type: copy
  #当前文件所在位置
  local_file: \"/tmp/test\"
  #文件传输目标位置
  remote_file: \"/tmp\"
- !ruby/object:Task
  type: command
  command: ls /tmp/test
targets:
- !ruby/object:Target
  ip: 127.0.0.1
  username: test
  password: '123456'
  user_ip: test@127.0.0.1
- !ruby/object:Target
  ip: 128.0.0.2
  username: ''
  password: ''
  user_ip: \"@128.0.0.2\"
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

YAML_LOGGER = LoggerUtil.new("yaml")
def writer_obj(op, src_file)
  case op
  when "ssh"
    writer_ssh(src_file)
  when "sc"
    writer_sc(src_file)
  else
    exit 0
  end
  YAML_LOGGER.info("writer yaml template file : #{src_file}")
end

def writer_sc(src_file)
  file_write(SC_TEMPLATE, src_file)
end

def writer_ssh(src_file)
  file_write(SSH_TEMPLATE, src_file)
end
