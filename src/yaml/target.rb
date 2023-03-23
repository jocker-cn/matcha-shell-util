# frozen_string_literal: true

require_relative '../util/ssh_util'

class Target

  attr_reader :ip, :username, :password, :user_ip, :interactive_password, :interactive_overwrite

  def initialize(ip, username, password)
    @ip = ip
    @username = username
    @password = password
    @user_ip = "#{@username}@#{@ip}"
  end


  def overwrite_keys
    "Overwrite (y/n)? "
  end

  def add_username(username)
    @username=username
    @user_ip = "#{@username}@#{@ip}"
  end
  def add_password(pwd)
    @password = pwd
  end

  def self.demo2
    return [Target.new("127.0.0.1", "test", "123456"), Target.new("128.0.0.2", "", "")]
  end
end