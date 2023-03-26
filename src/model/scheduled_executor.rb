# frozen_string_literal: true

require_relative '../util/file_util'
require_relative '../util/logger_util'
require 'ruby_expect'

SC_LOGGER = LoggerUtil.new("schedule")

class ScheduledExecutor
  include Executors

  def initialize(obj)
    username = obj.unit_username
    password = obj.unit_password

    @task_wrappers = []
    obj.tasks.each do |task|
      @task_wrappers.push(TaskWrapper.new(task))
      SC_LOGGER.info("create task name: #{task.name}")
    end

    abort "Schedule tasks cannot be empty" if @task_wrappers.empty?

    @targets = []
    obj.targets.each do |target|
      if target.username != nil
        @targets.push(target)
        next
      end
      if username != nil
        target.add_username(username)
        target.add_password(password) if password != nil && target.password == nil
        @targets.push(target)
        next
      end
    end

    abort "Targets scheduling machine address cannot be empty,please check [-s] or yaml file label 'targets' " if @targets.empty?
  end

  def exec
    @targets.each do |target|
      TASK_LOGGER.info("task schedule at #{target.user_ip}")
      @task_wrappers.each do |wrapper|
        wrapper.exec(target)
      end
    end
  end
end

class TaskWrapper

  attr_reader :name

  def initialize(task)
    # 操作类型
    @type = task.type
    @name = task.name
    # 文件执行
    if is_command
      command_op(task)
      @run = proc { |target|
        shell_op(target)
      }
    end
    # 文件拷贝
    if is_copy
      copy_op(task)
      @run = proc { |target|
        scp_op(target)
      }
    end
  end

  def exec(target)
    @run.call(target)
  end

  def shell_op(target)
    user_ip = target.user_ip
    password = target.password
    if @command != nil
      scp_command = sprintf(@ssh_command, user_ip)
      # 执行命令
      TASK_LOGGER.info("[#{@name}] ssh_command: #{scp_command} ")
      ssh_op(scp_command, password)
    else
      TASK_LOGGER.warn("[#{@name}] ssh_command: no command ")
    end
  end

  def scp_op(target)
    user_ip = target.user_ip
    password = target.password
    if @scp_command != nil
      scp_command = sprintf(@scp_command, user_ip)
      # 执行命令
      SC_LOGGER.info("[#{@name}] execution shell: #{scp_command}")
      ssh_op(scp_command, password)
    else
      SC_LOGGER.info("[#{@name}] exec failed: no files to copy")
    end
  end

  def ssh_op(command, password)
    spawn_instance = RubyExpect::Expect.spawn(command)
    spawn_instance.procedure do
      index = 0
      error = 0
      while index != 2 do
        begin
          index = any do
            expect "(yes/no/[fingerprint])? " do
              send "yes\n"
            end
            expect(/password:\s*$/) do
              send password
            end
            expect(/\$\s*$/) do
              send ""
            end
          end
        rescue Exception => e
          TASK_LOGGER.warn("exec failed: #{e}")
          return
        end
        if error == 2
          TASK_LOGGER.warn("skip current machine; please check your username or password")
          return
        end
        error += 1
      end
    end
  end

  def command_op(task)
    @command = task.command
    @ssh_command = "ssh %s #{@command}"
  end

  def copy_op(task)
    @scp_command = nil
    local_file = task.local_file
    remote_file = task.remote_file
    if copy_dir_check(local_file, remote_file)
      @scp_command = "/usr/bin/scp -r #{@local_file}  %s:#{@remote_file}"
    end
  end

  def copy_dir_check(local_file, remote_file)

    @local_file = File.expand_path(local_file)
    @remote_file = File.expand_path(remote_file)

    if @local_file == "" || @local_file == nil
      SC_LOGGER.warn("local_file must not be nil")
      return false
    end

    if @remote_file == "" || @remote_file == nil
      SC_LOGGER.warn("remote_file must not be nil")
      return false
    end

    true
  end

  def is_copy
    @type == "copy"
  end

  def is_command
    @type == "command"
  end

end
