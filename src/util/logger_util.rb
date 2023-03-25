# frozen_string_literal: true
require 'logger'
require_relative 'env_util'

# [时间][IP][操作类型][日志信息]
FIXED_FORMAT = "[%s][%s]%s \n"
ERROR_TEMPLATE = "\033[0;31;1m#{FIXED_FORMAT} \e[0m"
INFO_TEMPLATE = "\033[0;32;1m#{FIXED_FORMAT} \e[0m"
WARN_TEMPLATE = "\033[0;33;1m#{FIXED_FORMAT}\e[0m"
MSG_MODEL_TEMPLATE = "[%s] %s"
MSG_DEFAULT_TEMPLATE = "%s"

class LoggerUtil
  def initialize(op)
    @logger = Logger.new(STDOUT)
    @logger.formatter = proc do |severity, datetime, progname, msg|
      # 日志级别模板
      msg_template = template_choose(severity)
      sprintf(msg_template, "#{datetime.strftime('%H:%M:%S')}", "#{op}", "#{msg}")
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

TASK_LOGGER= LoggerUtil.new("task")