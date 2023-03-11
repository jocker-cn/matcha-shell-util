# frozen_string_literal: true
require_relative 'executors'

class FileExecutor < ExecutorOpt

  def initialize(models)
    @models = models
    @file = models.args
  end

  def exec
    super
  end
end
