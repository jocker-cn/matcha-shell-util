# frozen_string_literal: true
require_relative '../util/env_util'
require_relative '../util/yaml_util'

class SSH

  attr_reader :master, :network_name, :unite_username, :unite_password, :each_other, :targets, :ssh_key_file, :ssh_copy_file

  def initialize(args = {})
    @master = args[:master]
    @network_name = args[:@network_name]
    @master = local_ip(@network_name) if @master == nil
    @unite_username = args[:@unite_username]
    @unite_password = args[:unite_password]
    @each_other = args[:each_other]
    @each_other = false if @each_other == nil

    raise "Can't find master IP address for #{@network_name} or master ip is empty,the yaml prop for 'master' '" if @master == nil && !@each_other

    @targets = args[:targets]

    raise "Source ips is empty, the yaml prop for 'target:[]' " if @targets.length == 0

    @ssh_key_file = args[:ssh_key_file]
    @ssh_copy_file = args[:ssh_copy_file]

    @ssh_key_file = "~/.ssh/id_rsa" if @ssh_key_file == nil
    @ssh_copy_file = "~/.ssh/id_rsa.pub" if @ssh_copy_file == nil
  end

  def to_s
    "<ssh: master: #{@master}, network_name: #{@network_name}, unite_username: #{@unite_username}, unite_password: #{@unite_password}, each_other: #{@each_other}, targets: #{@targets}, ssh_key_file: #{@ssh_key_file}, ssh_copy_file: #{@ssh_copy_file}>"
  end
end

class Target

  attr_reader :ip, :username, :password

  def initialize(ip, username, password)
    @ip = ip
    @username = username
    @password = password
  end
end

def yaml_to_ssh(yaml)
  yaml_file(yaml) do |obj|
    targets = []
    obj["ssh"]["target"].each { |target|
      targets.push(Target.new(target["ip"], target["username"], target["password"]))
    }
    SSH.new(
      master: obj["master"],
      network_name: obj["network_name"],
      unite_username: obj["unite_username"],
      unite_password: obj["unite_password"],
      each_other: obj["each_other"],
      ssh_key_file: obj ["ssh_key_file"],
                        ssh_copy_file: obj["ssh_copy_file"],
                        targets: targets)
  end
end
