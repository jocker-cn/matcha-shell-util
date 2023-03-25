# frozen_string_literal: true
require_relative 'target'

class Schedule

  attr_reader :unit_username, :unit_password, :tasks, :targets

  def initialize(sc = {})
    @unit_username = sc[:unit_username]
    @unit_password = sc[:unit_password]
    @tasks = sc[:tasks]
    @targets = sc[:targets]
  end

  def self.example
    Schedule.new(
      unit_username: "root",
      unit_password: "123456",
      tasks: Task.demo2,
      targets: Target.demo2
    )
  end

  def self.yaml_to_ssh(yaml)
    yaml_file(yaml) do |obj|
      targets = []
      obj["schedule"]["target"].each { |target|
        targets.push(Target.new(target["ip"], target["username"], target["password"]))
      }
      tasks = []
      obj["schedule"]["tasks"].each { |target|
        tasks.push(Task.new(type: target["type"], file_dir: target["file_dir"], source_dir: target["password"], command: target["command"]
        ))
      }

      Schedule.new(
        unit_username: obj["schedule"]["unit_username"],
        unit_password: obj["schedule"]["unit_password"],
        tasks: tasks,
        targets: targets)
    end
  end

end

class Task

  attr_reader :type, :local_file, :remote_file, :command, :name

  TASK_TYPE_COMMAND = "command"
  TASK_TYPE_COPY = "copy"

  def initialize(task = {})
    @type = task[:type]
    @name = task[:name]
    if @type.eql?(TASK_TYPE_COPY)
      copy_init(task)
    elsif @type.eql?(TASK_TYPE_COMMAND)
      command_init(task)
    end
  end

  def copy_init(task = {})
    @local_file = task[:local_file]
    @remote_file = task[:remote_file]
  end

  def command_init(task = {})
    @command = task[:command]
  end

  def self.demo2
    return [copy, command]
  end

  def self.copy
    Task.new(
      type: TASK_TYPE_COPY,
      local_file: "/tmp/test",
      remote_file: "/tmp"
    )
  end

  def self.command
    Task.new(
      type: TASK_TYPE_COMMAND,
      command: "ls /tmp/test"
    )
  end

end
