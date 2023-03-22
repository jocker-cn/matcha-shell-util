# frozen_string_literal: true
require_relative '../util/env_util'
require_relative '../util/file_util'
require_relative '../yaml/ssh'
require_relative '../yaml/schedule'
require_relative '../service/man_docs'

class ArgsResolve
  def resolve(option) end

  def options(args)
    option = {}
    while args.length != 0
      op = args.shift
      option["#{op}"] = args.shift
    end
    resolve(option)
  end
end

# -i  指定源ip地址  即发起操作的ip地址
# -s  目标ip地址   即为目标完成ssh互信的ip地址
# -u  目标ip的用户
# -p  目标ip的用户密码
# 此规则支持批量操作，但是批量操作的目标机器用户和密码必须相同
# matcha ssh -i localhost -u test -p 123456 -s  192.168.1.2,192.168.1.3,192.168.1.4
# 如果每台机器的用户密码不同请使用yaml文件的方式
# matcha ssh -f ssh.yml
# 获取ssh yaml格式内容可使用 matcha yaml ssh
class SshResolve < ArgsResolve

  KEY_I = "-i"
  KEY_S = "-s"
  KEY_U = "-u"
  KEY_P = "-p"
  KEY_F = "-f"

  def resolve(option)
    ssh_create(option)
  end

  def ssh_create(option)
    @use_yaml = option.has_key?("#{KEY_F}")
    ssh = nil
    if @use_yaml
      yaml_file = option[KEY_F]
      ssh = SSH.yaml_to_ssh(yaml_file) if is_file(yaml_file)
    end

    source_ips = option[KEY_S].to_s.split(",")
    # 未指定目标ip 也没有使用yaml文件 则无法进行ssh操作
    if source_ips.length <= 0 && !@use_yaml
      abort "ssh model: ssh target ip must not be nil,if u need help,u can exec 'matcha support ssh'"
    end
    # 命令参数中的内容要与yaml文件中的内容合并
    targets = []
    source_ips.each do |ip|
      targets.push(Target.new(ip, option[KEY_U], option[KEY_P]))
    end

    if ssh == nil
      ssh = SSH.new(
        master: option[KEY_I],
        unite_username: option[KEY_U],
        unite_password: option[KEY_P],
        targets: targets
      )
    else
      ssh.add_targets(targets)
    end
    # 未指定目标ip
    if ssh.targets.length == 0
      abort "ssh model: ssh target ip must not be nil,if u need docs,u can exec 'matcha support ssh'"
    end
    ssh
  end
end

# -c 命令
# -f yaml文件
# -s 目标ip地址
# -e 可执行文件
# -u 目标机器username
# -p 目标机器password
class ScheduledResolve < ArgsResolve
  SC_KEY_C = "-c"
  SC_KEY_F = "-f"
  SC_KEY_S = "-s"
  SC_KEY_E = "-e"
  SC_KEY_U = "-u"
  SC_KEY_P = "-p"

  def resolve(option)
    create_schedule(option)
  end

  def create_schedule(option)
    yaml_file = option[SC_KEY_F]
    schedule = nil
    schedule = Schedule.yaml_to_ssh(yaml_file) if is_file(yaml_file)

    targets = []

    ips = option[SC_KEY_S]
    ips.each do |ip|
      targets.push(Target.new(ip, option[SC_KEY_U], option[SC_KEY_P]))
    end

    schedule = Schedule.new(
      command: option[SC_KEY_C],
      exec_file: option[SC_KEY_E],
      targets: targets
    ) if schedule == nil

    schedule
  end
end

class InstallResolve < ArgsResolve
  def resolve(option) end
end

class YamlResolve < ArgsResolve

  def resolve(option)

  end

end

class SupportResolve < ArgsResolve

  CONTEXT = {
    "all" => ALL_MAN,
    "ssh" => SSH_MAN,
    "sc" => SCHEDULE_MAN,
  }

  def resolve(option)
    help_man = CONTEXT[option]
    abort "No supported model #{option} content was found. Please try [matcha support all] to view the supported content." if help_man == nil
    puts help_man
  end
end

SSH_ARGS = {
  :ssh => SshResolve.new,
  :sc => ScheduledResolve.new,
  :install => InstallResolve.new,
  :yaml => YamlResolve.new,
  :support => SupportResolve.new,
}

def choose(op)
  SSH_ARGS[:"#{op}"]
end