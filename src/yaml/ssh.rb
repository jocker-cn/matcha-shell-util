# frozen_string_literal: true
require_relative '../util/env_util'
require_relative '../util/yaml_util'
require_relative 'target'

class SSH

  attr_reader :master, :network_name, :unite_username, :unite_password, :each_other, :targets, :ssh_pub_key, :authorized_keys, :is_local

  def initialize(args = {})
    @master = args[:master]
    @network_name = args[:@network_name]
    @master = local_ip(@network_name) if @master == nil
    @unite_username = args[:unite_username]
    @unite_password = args[:unite_password]
    @each_other = args[:each_other]
    @each_other = false if @each_other == nil

    abort "Can't find master IP address for #{@network_name} or master ip is empty,the yaml prop for 'master' '" if @master == nil && !@each_other

    @targets = args[:targets]

    abort "Source ips is empty, the yaml prop for 'target:[]' " if @targets == nil || @targets.length == 0

    @ssh_pub_key = args[:ssh_pub_key]
    @authorized_keys = args[:authorized_keys]

    @ssh_pub_key = "~/.ssh/id_rsa.pub" if @ssh_pub_key == nil
    @authorized_keys = "~/.ssh/authorized_keys" if @authorized_keys == nil
    @is_local = local
  end

  def self.example
    return SSH.new(
      master: "127.0.0.1",
      network_name: "eth0",
      unite_username: "root",
      unite_password: "123456",
      each_other: true,
      ssh_pub_key: "~/.ssh/id_rsa.pub",
      authorized_keys: "~/.ssh/authorized_keys",
      targets: Target.demo2
    )
  end

  def to_s
    "<ssh: master: #{@master}, network_name: #{@network_name}, unite_username: #{@unite_username}, unite_password: #{@unite_password}, each_other: #{@each_other}, targets: #{@targets}, ssh_key_file: #{@ssh_key_file}, ssh_copy_file: #{@ssh_copy_file}>"
  end

  def local
    @master == local_ip(nil)
  end

  def add_targets(targets)
    @targets.concat(targets)
  end

  def self.yaml_to_ssh(yaml)
    yaml_file(yaml) do |obj|
      targets = []
      obj["ssh"]["target"].each { |target|
        target["username"] == nil ? username = target["username"] : username = obj["unite_username"]
        target["password"] == nil ? password = target["password"] : password = obj["unite_password"]
        targets.push(Target.new(target["ip"], username, password))
      }
      SSH.new(
        master: obj["master"],
        network_name: obj["network_name"],
        unite_username: obj["unite_username"],
        unite_password: obj["unite_password"],
        each_other: obj["each_other"],
        ssh_pub_key: obj ["ssh_pub_key"],
                         authorized_keys: obj["authorized_keys"],
                         targets: targets)
    end
  end
end