# frozen_string_literal: true

require_relative 'model_wrapper'
require_relative 'check'


class ModelCheck < Check
  def initialize(k)
    super(k)
  end

  def check_obj
    super
  end
end

class Support
  def initialize(options)
    map = {}
    options.each { |k, v|
      map[k] = v if check(k)
    }
    @map = map
  end

  # 参数校验
  def check(k)
    new_check(k).check_obj
  end

  def call
    if @map.empty?
      return
    end
    ModelWrapper.new(@map).run
  end
end
