# frozen_string_literal: true

require_relative './args_resolve'
require_relative '../model/ssh_executor'
require_relative '../model/installer_executor'
require_relative '../model/scheduled_executor'

class Support
  def initialize(parse, options)
    @args_resolve = parse
    @options = options
  end

  def do_it
    obj = @args_resolve.options(@options)

    executor = choose_executor(@args_resolve,obj)

    abort "not support the model: #{model}. you can use 'matcha support all' for help " if executor == nil

    executor.exec
  end
end

def choose_executor(resolve_class, obj)

  abort "not support the model: #{model}. you can use 'matcha support all' for help " if resolve_class == nil

  if resolve_class.class == SshResolve
    return  SSHExecutor.new(obj)
  end

  if resolve_class.class == ScheduledResolve
    return  ScheduledExecutor.new(obj)
  end

  if resolve_class.class == InstallResolve
    return InstallerExecutor.new(obj)
  end

  BASE_Executors.new(obj)
end