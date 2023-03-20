# frozen_string_literal: true
#!/usr/bin/ruby -w
# -*- coding: UTF-8 -*-

require 'optparse'
require_relative './util/constant'
require_relative './util/logger_util'
require_relative './util/ssh_util'
require_relative './support/support'

APP_RUN_LOGGER = LoggerUtil.new("MATCHA")

ARGS = ARGV
options = {}
=begin
OptionParser.new do |opts|
  opts.on("", k.get_option_alisa, k.get_elem, k.get_option_type, k.help) do |files|
    options["#{opk}"] = files
  end
end.parse!
=end

class Start
  def run(options)
    APP_RUN_LOGGER.info("matcha start")
    APP_RUN_LOGGER.info("matcha request #{options.to_s}")
    Support.new.call
  end
end

class ArgsParse
  def initialize(args)
    args
  end
end

# Start.new.run(options)

# 连接远程主机
require 'net/ssh'

# s = "[y/N]：".to_s.dup.force_encoding('ASCII-8BIT')
s1 = "password: ".to_s.dup.force_encoding('ASCII-8BIT')

=begin
Net::SSH.start("192.168.112.129", "root", password: "123456") do |ssh|
  ssh.open_channel do |channel|
    channel(channel, "192.168.112.129", LoggerUtil.new("test"), "ls /root")
  end

    spawn_instance = RubyExpect::Expect.spawn("ssh-copy-id -o  StrictHostKeyChecking=no -i  ~/.ssh/id_rsa.pub test6@192.168.112.128",pty: true)
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
=end

# s = " matcha ssh -i localhost -u test -p 123456 -s  192.168.1.2,192.168.1.3,192.168.1.4"

ar = %w[-i localhost -s 192.168.1.2,192.168.1.3,192.168.1.4]

op = {}

while ar.length != 0
  op["#{ar.shift}"] = [ar.shift]
end

puts op




