# frozen_string_literal: true
require_relative 'models'
require_relative '../model/file_executor'
require_relative '../model/installer_executor'
require_relative '../model/executors'

class EventGroup
  def initialize(models, async, &block)
    @models = models
    @executors = model_executor(models)
    @async = async
    @thread = Thread.new{}
    @block = block
    @block = proc { @executors.exec } if @block == nil
    @value = nil
  end

  def run
    if @async
      @thread.start(@block)
    else
      @value = @block.call
    end
  end

  def get
    if @async ? @thread.value : @value
    end
  end

  def model_executor(models)
    case models.model
    when F || FILE
      FileExecutor.new(models)
    when I || INSTALL
      InstallerExecutor.new(models)
    else
      ExecutorOpt.new(models)
    end
  end
end
