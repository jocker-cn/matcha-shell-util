# frozen_string_literal: true

require_relative '../util/user_util'
require_relative 'model'

class ModelScheduler
  def initialize(model, args,async)
      @model = model,
      @args = args,
      @async=async,
      @username = get_user,
      @group = get_group
      @pwd = get_pwd
  end
end