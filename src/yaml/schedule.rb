# frozen_string_literal: true
require_relative 'target'

class Schedule

  attr_reader :command, :is_command, :corn, :once, :is_local, :targets, :exec_file

  def initialize(sc = {})

    @command = sc[:command]
    # 命令
    @command != nil ? @is_command = true : @is_command = false
    # corn表达式 如果不给corn表达式则默认只执行一次
    @corn = sc[:corn]

    @corn == nil ? @once = true : @once = false

    # 是否是本机操作  如果是本机操作 则目标ip 集合可以为空
    @is_local = sc[:is_local]
    # ip地址集合
    @targets = sc[:targets]
    @is_local = true if @targets.empty?
    # 可执行文件路径 如果is_command为true 则exec_file 可以为空
    @exec_file = sc[:exec_file]
    args_check
  end

  def self.example
    Schedule.new(
      command: "touch /tmp/test",
      corn: "* * * * * *",
      is_local: false,
      exec_file: "/tmp/test.sh",
      targets: Target.demo2
    )
  end

  def args_check
    # 是命令
    unless @command != nil || @exec_file != nil
      abort "Schedule model: @command or @exec_file both cannot be nil"
    end

    if !@is_local && @targets.empty?
      abort "Schedule model: @is_local or @targets both cannot be nil"
    end
  end

  def self.yaml_to_ssh(yaml)
    yaml_file(yaml) do |obj|
      targets = []
      obj["schedule"]["target"].each { |target|
        targets.push(Target.new(target["ip"], target["username"], target["password"]))
      }
      Schedule.new(
        is_command: obj["is_command"],
        corn: obj["corn"],
        once: obj["once"],
        command: obj["command"],
        is_local: obj["is_local"],
        exec_file: obj ["exec_file"],
                       targets: targets)
    end
  end

end

