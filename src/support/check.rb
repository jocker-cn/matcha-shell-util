# frozen_string_literal: true
require_relative '../util/constant'

class Check
  def initialize(k)
    @obj=k
  end
  def check_obj
    true
  end
end

def new_check(k)
  if k == I || k == INSTALL
    Check.new(k)
  elsif k == F || k == FILE
    ModelCheck.new(k)
  end
  Check.new(k)
end