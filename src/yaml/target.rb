# frozen_string_literal: true

require_relative '../util/ssh_util'

class Target

  attr_reader :ip, :username, :password, :user_ip, :interactive_password, :interactive_overwrite

  def initialize(ip, username, password)
    @ip = ip
    @username = username
    @password = password
    @user_ip = "#{@username}@#{@ip}"
    # ssh 密码交互匹配
    @interactive_password = match_password_pre
    @interactive_overwrite = overwrite_keys

    @ssh_copy_shell = SSH_COPY + @ip
  end

  def match_password_pre
    @user_ip + "'s password: "
  end

  def overwrite_keys
    "Overwrite (y/n)? "
  end

end