# frozen_string_literal: true
require 'logger'
require_relative 'env_util'

ERROR_TEMPLATE = "\033[0;31;1m %s \e[0m"
INFO_TEMPLATE = "\033[0;32;1m %s \e[0m"
WARN_TEMPLATE = "\033[0;33;1m %s\e[0m"
MSG_MODEL_TEMPLATE = "[%s] [%s] %s"
MSG_DEFAULT_TEMPLATE = "%s"

class LoggerUtil
  def initialize(clas)
    @logger = Logger.new(STDOUT)
    @logger.formatter = proc do |severity, datetime, progname, msg|
      msg_template = template_choose(severity)
      msg = sprintf(msg_template, "#{msg}")
      "[#{datetime.strftime('%H:%M:%S')}][#{local_ip(nil)}][#{clas}]#{msg} \n"
    end
  end

  def info(msg)
    @logger.info(sprintf(MSG_DEFAULT_TEMPLATE, msg))
  end

  def error(msg)
    @logger.error(sprintf(MSG_DEFAULT_TEMPLATE, msg))
  end

  def warn(msg)
    @logger.warn(sprintf(MSG_DEFAULT_TEMPLATE, msg))
  end

  def info_model(model, op, msg)
    @logger.info(sprintf(MSG_MODEL_TEMPLATE, model,op, msg))
  end

  def error_model(model, op, msg)
    @logger.error(sprintf(MSG_MODEL_TEMPLATE, model, op, msg))
  end

  def warn_model(model, op, msg)
    @logger.warn(sprintf(MSG_MODEL_TEMPLATE, model, op, msg))
  end

  def template_choose(severity)
    case severity.to_s
    when "INFO"
      INFO_TEMPLATE
    when "ERROR"
      ERROR_TEMPLATE
    when "WARN"
      WARN_TEMPLATE
    else
      INFO_TEMPLATE
    end
  end
end
