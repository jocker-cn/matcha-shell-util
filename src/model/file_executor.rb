# frozen_string_literal: true

class FileExecutor
  include Executors

  def initialize(op, file)
    @op = get_op(op)
    @file = file
  end

  def exec
    @op.ec(@file)
  end
end

def get_op(op)
  CreateOP
end

class OPFile
  def ec(file) end
end

class CreateOP < OPFile
  def ec(file)
  end
end
