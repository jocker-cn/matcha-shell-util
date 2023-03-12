# frozen_string_literal: true
#!/usr/bin/ruby -w
# -*- coding: UTF-8 -*-

require 'optparse'
require_relative './util/constant'
require_relative './util/logger_util'
require_relative './support/support'

APP_RUN_LOGGER = LoggerUtil.new("start")

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
    APP_RUN_LOGGER.info_model("matcha", "shell", "start")
    APP_RUN_LOGGER.info_model("matcha", "request", options.to_s)
    Support.new(options).call
  end
end

Start.new.run(options)

