# frozen_string_literal: true
require_relative 'model_scheduler.rb'
require_relative '../util/logger_util'

LOGGER ||= LoggerUtil.new("ModelWrapper")

class ModelWrapper
  def initialize(map)
    @mms = {}
    modified_map = map.map.with_index do |k, v|
      LOGGER.info_model(k, v, "ModelWrapper creator")
      [creator(k, v), order(k)]
    end
    @mms.merge!(modified_map.to_h)
    sort(@mms) unless @mms.empty?
  end

  def sort(mms)
    mms.sort_by { |_, order| -order }
  end

  def creator(k, v)
    ModelScheduler.new(Models.new(k, v), is_async(k))
  end

  def is_async(k)
    false
  end

  def run
    @mms.each do |k, v|
      k.run
    end
  end

  private :is_async, :sort, :creator
end

