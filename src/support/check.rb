# frozen_string_literal: true
require_relative '../util/constant'

class Check
  def initialize(k)
    @obj=k
  end
  def check(*)
    true
  end
end

def new_check(k)
  if k == I || k == INSTALL
    Check
  elsif k == F || k == FILE
    ModelCheck
  end
  Check
end