# frozen_string_literal: true
#!/usr/bin/ruby -w
# -*- coding: UTF-8 -*-

require 'optparse'
require_relative './util/constant'
require_relative './util/http_util'
require_relative './util/env_util'
require_relative './util/file_util'
require_relative './support/support'
require_relative './model/DockerService'


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
    Support.new(options).call
  end
end

# Start.new.run(options)


# puts RbConfig::CONFIG['host_cpu'].include?("")
# puts RbConfig::CONFIG
# puts get_env_default("GEM_HOME","23")

bytes = file_write(CONTAINERD_SERVICE,"d:\\a.txt")
puts bytes
puts CONTAINERD_SERVICE.length
puts CONTAINERD_SERVICE.length <= bytes if bytes != nil
