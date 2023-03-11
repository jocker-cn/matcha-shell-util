# frozen_string_literal: true
require_relative '../support/models'

module Executors
  def exec

  end
end

class ExecutorOpt
  include Executors

  def initialize(models)
    @models = models
  end

  def model
    @models.model
  end

  def args
    @models.args
  end
end
