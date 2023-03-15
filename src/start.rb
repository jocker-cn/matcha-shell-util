# frozen_string_literal: true
#!/usr/bin/ruby -w
# -*- coding: UTF-8 -*-

require 'optparse'
require_relative './util/constant'
require_relative './util/logger_util'
require_relative './util/ssh_util'
require_relative './support/support'

APP_RUN_LOGGER = LoggerUtil.new("MATCHA")

options = {}
OptionParser.new do |opts|
  OP_COLL_ARRAY.each { |k|
    opk = k.get_option
    opts.on(opk, k.get_option_alisa, k.get_elem, k.get_option_type, k.help) do |files|
      options["#{opk}"] = files
      options["#{opk}"] += ARGV.take_while { |arg| arg !~ /^-/ }
    end
  }

  OP_COLL_ONE_ARGS.each { |k|
    opk = k.get_option
    opts.on(opk, k.get_option_alisa, k.get_elem, k.get_option_type, k.help) do |files|
      options["#{opk}"] = files
      options["#{opk}"] += ARGV.take_while { |arg| arg !~ /^-/ } if k.get_elem.class == Array.class
    end
  }

  OP_COLL_NO_ARGS.each { |k|
    opk = k.get_option
    opts.on(opk, k.get_option_alisa, k.get_elem, k.get_option_type, k.help) do |files|
      options["#{opk}"] = files
    end
  }
end.parse!

class Start
  def run(options)
    APP_RUN_LOGGER.info("matcha start")
    APP_RUN_LOGGER.info("matcha request #{options.to_s}")
    Support.new(options).call
  end
end

# Start.new.run(options)

# 连接远程主机
require 'net/ssh'

# Net::SSH.start('192.168.112.129', 'test', password: '123456') do |ssh|
#   # 假设此命令需要输入 Y/N 响应
#   ssh.exec!("ssh-copy-id -o  StrictHostKeyChecking=no -i  ~/.ssh/id_rsa.pub test@192.168.112.128") do |ch, stream, data|
#     if data =~ /password:/
#       # 模拟输入 Y 响应
#       ch.send_data("123456\n")
#     else
#       # 输出命令的输出
#       puts data
#     end
#   end
# end

# s = "[y/N]：".to_s.dup.force_encoding('ASCII-8BIT')
s1 = "password: ".to_s.dup.force_encoding('ASCII-8BIT')

Net::SSH.start("192.168.112.129", "test", password: "123456") do |ssh|
  ssh.open_channel do |channel|
    spawn_instance = RubyExpect::Expect.spawn("ssh-copy-id -o  StrictHostKeyChecking=no -i  ~/.ssh/id_rsa.pub test6@192.168.112.128",pty: true)
    # spawn_instance = RubyExpect::Expect.spawn("touch /tmp/test1.bak")
    # spawn_instance.timeout = 10

    spawn_instance.procedure do
      any do
        expect s1 do
          send '123456'
        end
      end
      begin
        each do
          expect /\$\s+$/ do
            send 'exit'
          end
        end
      rescue Exception => e
        puts e
      end
    end
    ssh.loop
  end
end