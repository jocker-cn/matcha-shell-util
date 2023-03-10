# frozen_string_literal: true

class Result
  SUCCESS = 200
  ERROR = 500

  def initialize(obj, code, msg)
    @obj = obj
    @code = code
    @msg = msg
  end

  def is_ok
    @code == SUCCESS
  end

  def is_error
    @code == ERROR
  end

  def ok_obj
    @obj if is_ok
  end

  def error_obj
    @msg if is_error
  end
end
