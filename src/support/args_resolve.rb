# frozen_string_literal: true
require_relative '../util/env_util'
require_relative '../util/file_util'
require_relative '../yaml/ssh'

class ArgsResolve
  def resolve(args) end
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

  @key_i = "-i"
  @key_s = "-s"
  @key_u = "-u"
  @key_p = "-p"
  @key_f = "-f"

  def check_op(op)
    unless op.eql?(@key_i) || op.eql?(@key_s) || op.eql?(@key_u) || op.eql?(@key_p)
      abort ""
      # todo 这里输出当前模块的help文档
    end
  end

  def resolve(args)
    option = {}
    while args.length != 0
      op = args.shift
      check_op(op)
      option["#{op}"] = args.shift
    end

    @use_yaml = option.has_key?(@key_f)

  end

  def ssh_create(option)
    yaml_file = option[@key_f]
    ssh = nil
    ssh = yaml_to_ssh(yaml_file) if is_file(yaml_file)
    source_ips = option[@key_s].to_s.split(",")
    # 未指定目标ip 也没有使用yaml文件 则无法进行ssh操作
    if source_ips.length <= 0 && !@use_yaml
      abort ""
      # todo 这里输出当前模块的help文档
    end
    # 命令参数中的内容要与yaml文件中的内容合并
    targets = []
    source_ips.each do |ip|
      targets.push(Target.new(ip, option[@key_u], option[@key_p]))
    end

    if ssh == nil
      ssh = SSH.new(
        master: option[@key_i],
        unite_username: option[@key_u],
        unite_password: option[@key_p],
        targets: targets
      )
    else
      ssh.add_targets(targets)
    end

    if ssh.targets.length == 0
      abort ""
      # todo 这里输出当前模块的help文档
    end

    ssh
  end
end

class ScheduledResolve < ArgsResolve
  def resolve(args) end
end

class InstallResolve < ArgsResolve
  def resolve(args) end
end

class YamlResolve < ArgsResolve
  def resolve(args) end
end

class SupportResolve < ArgsResolve
  def resolve(args) end
end

SSH_ARGS = {
  :ssh => SshResolve,
  :sc => ScheduledResolve,
  :install => InstallResolve,
  :yaml => YamlResolve,
  :support => SupportResolve,
}
