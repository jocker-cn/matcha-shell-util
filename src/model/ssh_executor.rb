# frozen_string_literal: true

require 'ruby_expect'

require_relative 'executors'

SSH_LOGGER = LoggerUtil.new("ssh")

SSH_KEYGEN = "ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N '' -q"
SSH_COPY = "ssh-copy-id -o  StrictHostKeyChecking=no -i  ~/.ssh/id_rsa.pub %s"
SSH_KEY_PASSWORD = "%s's password: "
SSH_KEY_OVERWRITE = "Overwrite (y/n)? "
SSH_KEY_FINGERPRINT = "Are you sure you want to continue connecting (yes/no/[fingerprint])? "
SSH_LOGIN = "ssh %s"

class SSHExecutor
  include Executors

  def initialize(obj)

    @original_address = obj.master

    @is_local = (local_ip(nil) == @original_address)

    @username = obj.unite_username

    @password = obj.unite_password

    @sources_ips = []
    initiate_ip = Target.new(@original_address, @username, @password)
    @initiate_ips = []
    # 不是本地操作
    if !@is_local && @username == nil
      abort 'Please provide the username of the target initiating machine. If the target machine does not have ssh mutual trust with the current machine, you must provide the password'
    end

    obj.targets.each do |target|
      source_ip = target.clone
      if source_ip.username == nil || source_ip.username == ""
        if @username == nil
          next
        end
        source_ip.add_username(@username)
      end

      if source_ip.password == nil || source_ip.password == ""
        if @password == nil
          next
        end
        source_ip.add_password(@password)
      end
      @sources_ips.push(source_ip)
    end

    @each_all = obj.each_other
    if @each_all
      @sources_ips.push(initiate_ip)
      @initiate_ips.concat(@sources_ips)
    else
      @initiate_ips.push(initiate_ip)
    end

    abort "no actionable targets,please check [targets] prop" if @sources_ips.empty?
    abort "unknown ssh originating machine" if @initiate_ips.empty?

  end

  def initiate_ips
    @initiate_ips
  end

  def sources_ips
    @sources_ips
  end

  def is_local_ip
    @is_local
  end

  def exec
    init_ips = initiate_ips
    ss_ips = sources_ips

    # 优先处理本地到目标机器
    local_generate
    ss_ips.each do |ss_ip|
      local_ssh(ss_ip.user_ip, ss_ip.password)
    end

    # 仅本地处理 则直接结束
    if is_local_ip
      exit 0
    end

    init_ips.each do |init_ip|
      ss_ips.each do |ss_ip|
        other_ssh(init_ip, ss_ip)
        SSH_LOGGER.info("[#{init_ip.ip}] #{ss_ip.user_ip} operation complete")
      end
    end
  end

  def local_generate
    ip = local_ip(nil)
    SSH_LOGGER.info("[#{ip}] generate ssh_key: ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N '' -q")
    overwrite_key = SSH_KEY_OVERWRITE.to_s.dup.force_encoding('ASCII-8BIT')
    spawn_instance = RubyExpect::Expect.spawn(SSH_KEYGEN)
    spawn_instance.procedure do
      each do
        expect overwrite_key do
          SSH_LOGGER.info("[#{ip}] Overwrite ssh_key: No")
          send "n\n"
        end
        expect(/\$\s*$/) do
          send ""
        end
      end
    end
  end
end

def local_ssh(source_ip_info, password)
  ip = local_ip(nil)
  SSH_LOGGER.info("[#{ip}] ssh-copy-id ssh_key to #{source_ip_info}")
  match_ssh_info = sprintf(SSH_KEY_PASSWORD, source_ip_info).to_s.dup.force_encoding('ASCII-8BIT')
  match_ssh_fingerprint = SSH_KEY_FINGERPRINT.to_s.dup.force_encoding('ASCII-8BIT')
  ssh_copy_command = sprintf(SSH_COPY, source_ip_info)
  spawn_instance = RubyExpect::Expect.spawn(ssh_copy_command)
  spawn_instance.procedure do
    begin
      eval = 0
      while eval != 2
        eval = any do
          expect match_ssh_fingerprint do
            SSH_LOGGER.info("[#{ip}] #{match_ssh_fingerprint} ")
            send 'yes'
          end
          expect match_ssh_info do
            SSH_LOGGER.info("[#{ip}] #{match_ssh_info} ")
            send password
          end
          expect(/\$\s*$/) do
            send "exit"
          end
        end
      end
    rescue Exception => e
      SSH_LOGGER.warn("[#{ip}] #{e} ")
    end
  end
end

def other_ssh(init_ip, source_ip)
  SSH_LOGGER.info("[#{init_ip.ip}] ssh-copy-id ssh_key to #{source_ip.ip}")
  match_ssh_info = sprintf(SSH_KEY_PASSWORD, source_ip.user_ip).to_s.dup.force_encoding('ASCII-8BIT')
  match_ssh_fingerprint = SSH_KEY_FINGERPRINT.to_s.dup.force_encoding('ASCII-8BIT')
  # ssh 互信命令
  ssh_copy_command = sprintf(SSH_COPY, source_ip.user_ip)
  # 登录命令
  ssh_login_c = sprintf(SSH_LOGIN, init_ip.user_ip)
  # 登录远程机器
  SSH_LOGGER.info("[#{init_ip.ip}] ssh to #{init_ip.ip}")
  spawn_instance = RubyExpect::Expect.spawn(ssh_login_c)
  spawn_instance.procedure do
    eval = 0
    login_f = 0
    while eval != 1
      eval = any do
        # 登录密码匹配
        expect(/password:\s*$/) do
          send "#{init_ip.password}"
        end
        # 构建本地密钥
        expect(/\$\s*$/) do
          SSH_LOGGER.info("[#{init_ip.ip}] #{SSH_KEYGEN}")
          send SSH_KEYGEN
        end
        # 尝试登录超过两次
        if login_f == 2
          SSH_LOGGER.error("#{ssh_login_c} login failed")
          return
        end
      end
      login_f += 1
    end

    # 本地密钥匹配
    any do
      expect SSH_KEY_OVERWRITE do
        SSH_LOGGER.info("[#{init_ip.ip}] #{SSH_KEY_OVERWRITE}: No")
        send "n\n"
      end
    end

    # ssh 互信
    any do
      expect(/\$\s*$/) do
        send ssh_copy_command
        SSH_LOGGER.info("[#{init_ip.ip}] #{ssh_copy_command} ")
      end
    end

    eval = 0
    # 是否有指纹验证
    while eval != 2 do
      eval = any do
        expect match_ssh_fingerprint do
          send 'yes'
          SSH_LOGGER.info("[#{init_ip.ip}] fingerprint match: yes ")
        end

        expect(/password:\s*$/) do
          send source_ip.password
          SSH_LOGGER.info("[#{init_ip.ip}] #{match_ssh_info} ")
        end

        expect(/\$\s*$/) do
          send "exit"
        end
      end
    end
  end
end