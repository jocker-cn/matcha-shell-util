# frozen_string_literal: true
#!/usr/bin/ruby -w
# -*- coding: UTF-8 -*-

require_relative './support/args_resolve'

APP_RUN_LOGGER = LoggerUtil.new("MATCHA")
ARGS = ARGV

def choose_parse(model)
  parse = choose(model)
  abort "matcha not support the model: #{model}. you can use 'matcha support all' for help " if parse == nil
  parse
end

class Start
  def run(options)
    args_resolve = choose_parse(options.shift)
    APP_RUN_LOGGER.info("matcha request #{options.to_s}")
    # Support.new(args_resolve,options).do
    args_resolve.options(options)
  end
end

# Start.new.run(ARGS)


puts   schedule_man = "MODEL_NAME:         schedule
MODEL_DESCRIPTION:  Used for scheduling jobs for commands or executable scripts.
                    This operation schedules the content of your command or script on the specified machine and executes it.
                    The IP address and username of the target machine must be specified during scheduling, and the target username@ip
                    must have completed SSH interconnection with the current machine.This operation supports two
                    execution modes: command-line and YAML file.
             use:  matcha sc [args]
             args: -c  Specify the command that needs to be scheduled for execution.
                       Example: -c 'touch /tmp'
                   -s  Specify the IP address(es) of the target machine(s) (can be multiple, separated by ',',
                       but the username and password for multiple machines must be the same).
                       Example: -s 127.0.0.1,127.0.0.2
                   -e  Specify the executable file (can be an absolute path or a relative path from the current location).
                       Example: -e '../test.sh'
                   -u  Specify the username of the target machine.
                       Example: -u root
                   -p  Specify the password of the target machine user.
                       Example: -p 123456
                   -f  Specify the YAML file (use matcha yaml sc to get the configurable content of the YAML file).
                       The contents of the YAML file can be mixed with command-line parameters.
                       Example: -f sc.yaml"





