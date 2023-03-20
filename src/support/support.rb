# frozen_string_literal: true

require_relative 'args_resolve'


def choose_resolve(key)
  if key != nil
    SSH_ARGS[:"#{key.to_s.downcase}"]
  end
end


class Support
  def initialize
  end
end
