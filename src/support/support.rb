# frozen_string_literal: true

require_relative 'model_choose'
require_relative 'check'
class ModelCheck < Check
  def initialize(k)
    super(k)
  end

  def check
    super
  end
end

class Support
  def initialize(options)
    map = []
    options.each { |k, v|
      map[k] = v if check(k)
    }
    @map = map unless map.empty?
  end

  def check(k)
    new_check(k).check
  end

  def call
    if @map.empty?
      return
    end
    ModelChoose.new(@map)
  end
end
