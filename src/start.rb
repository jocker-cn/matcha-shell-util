# frozen_string_literal: true
#!/usr/bin/ruby -w
# -*- coding: UTF-8 -*-

require_relative './support/args_resolve'
require_relative './util/user_util'

APP_RUN_LOGGER = LoggerUtil.new("MATCHA")
ARGS = ARGV

def choose_parse(model)
  parse = choose(model)
  abort "matcha not support the model: #{model}. you can use 'matcha support all' for help " if parse == nil
  parse
end

class Start
  def run(options)
    APP_RUN_LOGGER.info("[#{get_user}]request #{options.to_s}")
    args_resolve = choose_parse(options.shift)
    Support.new(args_resolve,options).do
  end
end

Start.new.run(ARGS)








