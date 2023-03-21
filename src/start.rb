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

Start.new.run(ARGS)





