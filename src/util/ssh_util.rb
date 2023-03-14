# frozen_string_literal: true
require 'net/ssh'
require 'net/scp'
require 'pty'
require 'expect'
require 'ed25519'
require 'bcrypt_pbkdf'

PORT = 22
SSH_FILE = "~/.ssh/id_rsa"
SSH_PUB_FILE = "~/.ssh/id_rsa.pub"

SSH_KEYGEN = "ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N '' -q"
SSH_COPY = "ssh-copy-id -o  StrictHostKeyChecking=no -i  ~/.ssh/id_rsa.pub "
SSH_KEY_PASSWORD = "root@192.168.112.128's password: "
SSH_KEY_OVERWRITE = "Overwrite (y/n)? "

class Console
  attr_reader :frequency, :match

  def initialize(frequency, timeout, match = {})
    @frequency = frequency
    @timeout = timeout
    @match = match
  end

end

class CoonProp

  attr_reader :host, :port, :user, :password, :timeout, :logger, :check_host_ip

  def initialize(host, port = PORT, map = {})
    @host = host
    @port = port
    @user = map[:user]
    @password = map[:password]
    @timeout = map[:timeout]
    @logger = map[:logger]
    @check_host_ip = map[:check_host_ip]

    @check_host_ip = false if @check_host_ip == nil
    @timeout = 5 if @timeout == nil
    @logger = LoggerUtil.new("SSH") if @logger == nil
  end

  def self.default(host, user, password = nil, logger = nil)
    new(host, user, password: password, check_host_ip: false, logger: logger)
  end

  def self.default_check(host, user, check_host_ip, password = nil, logger = nil)
    new(host, user, password: password, check_host_ip: check_host_ip, logger: logger)
  end

end

def ssh_none(coon_prop, skip = false, *shell)
  logger = coon_prop.logger
  result = false
  Net::SSH.start(coon_prop.host, coon_prop.user, password: coon_prop.password, check_host_ip: coon_prop.check_host_ip) do |ssh|
    result = ssh_channel(ssh, logger, coon_prop.host, shell_append(shell), skip: skip)
    ssh.loop
  end
  logger.info("[#{coon_prop.host}] ssh  finish")
  result
end

def shell_append(*shell)
  commands = ""
  shell.each do |sh|
    commands += "#{sh};"
  end
  commands
end

def channel(channel, host, logger, error_skip, command)
  channel.exec(command) do |_, success|
    if success
      channel.on_data do |_, data|
        logger.info("[#{host}]: #{data}")
      end
      channel.on_extended_data do |_, type, data|
        logger.info("[#{host}] info: #{data}") if type == 0
        logger.error("[#{host}] error: #{data}") if type == 1
      end
      channel.on_request("exit-status") do |_, data|
        logger.info("#{host}  exit-status: #{data.read_long}")
      end
    else
      if error_skip
        return false
      end
    end
  end
end

def ssh_channel(ssh, logger, host, error_skip = false, *shell)
  logger.info("[#{host}] ssh start")
  shell.each do |command|
    ssh.open_channel do |channel|
      channel(channel, host, logger, error_skip, command)
    end
  end
  true
end

def ssh_scp(coon_prop, local_file)
  Net::SSH.start(coon_prop.host, coon_prop.user, password: coon_prop.password, check_host_ip: coon_prop.check_host_ip) do |ssh|
    ssh.open_channel do |channel|
      scp_file(channel, coon_prop.logger, local_file)
    end
    ssh.loop
  end
end

def scp_file(channel, logger, local_file)
  unless File.exist?(local_file)
    logger.error("scp file fail: #{local_file} does not exist")
    return false
  end

  channel.exec("scp -t #{local_file}") do |ch, success|
    unless success
      logger.error("SCP failed to start session: #{ch[:data]}")
      return false
    end

    # Send file content to remote host
    File.open(local_file, 'rb') do |file|
      ch.send_data("C0644 #{File.size(local_file)} #{File.basename(local_file)}\n")
      ch.send_data(file.read)
      ch.send_data("\x00")
    end

    # Signal end of file transfer
    ch.eof!
  end
  true
end

def ssh_exec_file(coon_prop, local_file, error_skip)
  Net::SSH.start(coon_prop.host, coon_prop.user, password: coon_prop.password, check_host_ip: coon_prop.check_host_ip) do |ssh|
    ssh.open_channel do |channel|
      scp_file(channel, coon_prop.logger, local_file)
    end

    ssh.open_channel do |channel|
      channel(channel, coon_prop.host, coon_prop.logger, error_skip, "bash #{local_file}")
    end
    ssh.loop
  end
end

def interactive_command(command, console)
  return if console == nil || (map = console.match).empty?
  frequency = console.frequency
  PTY.spawn(command) do |r, w, pid|
    while (frequency) != 0 do
      if r.expect(/:/, console.timeout) do |ma|
        map.each do |k, v|
          if ma.to_s.match?(/#{k}/)
            INTERACT_LOGGER.info("match : #{ma}")
            w.puts "#{v}"
          end
        end
        frequency -= 1
      end
      end
    end
  end
end
