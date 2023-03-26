# frozen_string_literal: true


module Executors
  def exec

  end
end

class BASE_Executors
  include Executors
  def initialize(obj)

  end

  def exec
    super
  end
end