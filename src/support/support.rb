# frozen_string_literal: true

require_relative 'args_resolve'

class Support

  def initialize(parse, options)
    @args_resolve = parse,
      @options = options
  end

  def do
    obj = @args_resolve.options(@options)
  end
end

OP_MAPPING = {

}
