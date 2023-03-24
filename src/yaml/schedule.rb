# frozen_string_literal: true
require_relative 'target'

class Schedule

  attr_reader :tasks, :targets

  def initialize(sc = {})
    @tasks = sc[:tasks]
    @targets = sc[:targets]
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

class Task

  TASK_TYPE_COMMAND = "command"
  TASK_TYPE_COPY = "copy"

  def initialize(task = {})
    @type = task[:type]
    @corn = task[:corn]
    if @type.eql?(TASK_TYPE_COPY)
      copy_init(task)
    elsif @type.eql?(TASK_TYPE_COMMAND)
      command_init(task)
    end
  end

  def copy_init(task = {})
    @file_dir = task[:file_dir]
    @source_dir = task[:source_dir]
  end

  def command_init(task = {})
    @command = task[:command]
    @command_file = task[:command_file]
  end

end
