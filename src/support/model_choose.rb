# frozen_string_literal: true
require 'optparse'
require_relative 'model_scheduler.rb'

class ModelWrapper
  def initialize(map)
    mms = {}
    map.each do |k, v|
      mms[creator(k, v)] = order(k)
    end
    @mms = sort(mms)
  end

  def sort(mms)
    mms.sort_by { |ms, order| -order }
  end

  def creator(k, v)
    ModelScheduler.new(k, v, is_async(k))
  end

  def is_async(k)
    false
  end

  private  :is_async, :sort, :creator
end

class ModelChoose
  def initialize(map)
    @map = map
    @mw = ModelWrapper.new(@map)
  end
end


