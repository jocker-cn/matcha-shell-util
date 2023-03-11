# frozen_string_literal: true
require 'net/ssh'
require 'net/scp'

PORT = 22

class AUTH_WAY
  PASSWORD = "password"
  PUBLICKEY = "publickey"
  NONE = "none"
end

class SSHWrapper
  attr_reader :host, :port, :auth_methods, :user, :password, :keys, :timeout, :logger

  def initialize(host, port = PORT, auth_methods, user, password, keys, timeout = 10, logger)
    @host = host
    @port = port
    @auth_methods = auth_methods
    @user = user
    @password = password
    @keys = keys
    @timeout = timeout
    @logger = logger
  end

end

def ssh_none(ssh_wrapper, *shell)
  logger = ssh_wrapper.logger
  Net::SSH.start(
    host: ssh_wrapper.host,
    port: ssh_wrapper.port,
    user: ssh_wrapper.user,
    password: ssh_wrapper.password,
    auth_methods: AUTH_WAY::NONE,
    timeout: ssh_wrapper.timeout) do |ssh|
=begin
    shell.each { |sh|
      ssh.exec!(sh) do |channel, stream, data|
        return if stream == :stderr
      end
    }
=end
    ssh_channel(ssh, logger, host, shell)
    ssh.loop
  end
  logger.info_model("[ssh]", "[#{ssh_wrapper.host}]", "end")
end

def ssh_password(ssh_wrapper, *shell)
  logger = ssh_wrapper.logger
  Net::SSH.start(
    host: ssh_wrapper.host,
    port: ssh_wrapper.port,
    user: ssh_wrapper.user,
    password: ssh_wrapper.password,
    auth_methods: AUTH_WAY::PASSWORD,
    timeout: ssh_wrapper.timeout) do |ssh|
=begin
    shell.each { |sh|
      ssh.exec!(sh) do |channel, stream, data|
        return if stream == :stderr
      end
    }
=end
    ssh_channel(ssh, logger, host, shell)
    ssh.loop
  end
  logger.info_model("[ssh]", "[#{ssh_wrapper.host}]", "end")
end

def ssh_keys(ssh_wrapper, *shell)
  logger = ssh_wrapper.logger
  Net::SSH.start(
    host: ssh_wrapper.host,
    port: ssh_wrapper.port,
    keys: ssh_wrapper.keys,
    auth_methods: AUTH_WAY::PUBLICKEY,
    timeout: ssh_wrapper.timeout) do |ssh|
=begin
    shell.each { |sh|
      ssh.exec!(sh) do |channel, stream, data|
        return if stream == :stderr
      end
    }
=end
    ssh_channel(ssh, logger, host, shell)
    ssh.loop
  end
  logger.info_model("[ssh]", "[#{ssh_wrapper.host}]", "end")
end

def ssh_channel(ssh, logger, host, *shell)
  logger.info_model("[ssh]", "[#{host}]", "start")
  ssh.open_channel do |channel|
    shell.each { |sh|
      channel.exec(sh) do |_, success|
        next unless success

        channel.on_data do |_, data|
          logger.info_model("[ssh]", "[#{host}]", data)
        end

        channel.on_extended_data do |_, type, data|
          logger.info_model("[ssh]", "[#{host}]", data) if type == 0
          logger.error_model("[ssh]", "[#{host}]", data) if type == 1
        end

        channel.on_request("exit-status") do |_, data|
          logger.info_model("[#{host}]", "[exit-status]", data.read_long)
        end
      end
    }
    channel.on_close {}
  end
end

def ssh_pub_pri_keys(ssh_wrapper, *shell)
  logger = ssh_wrapper.logger
  Net::SSH.start(
    host: ssh_wrapper.host,
    port: ssh_wrapper.port,
    user: ssh_wrapper.user,
    timeout: ssh_wrapper.timeout) do |ssh|
    ssh_channel(ssh, logger, host, shell)
    ssh.loop
  end
  logger.info_model("[ssh]", "[#{host}]", "end")
end

def ssh_scp(ssh_wrapper, local_file, remote_file)
  Net::SSH.start(
    host: ssh_wrapper.host,
    port: ssh_wrapper.port,
    user: ssh_wrapper.user,
    password: ssh_wrapper.password,
    forward_agent: true,
    timeout: ssh_wrapper.timeout) do |ssh|
    ssh.exec!("mkdir -p  #{remote_file}")
    return ssh.scp.upload!(local_file, remote_file)
  end
end