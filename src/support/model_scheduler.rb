# frozen_string_literal: true

require_relative '../util/user_util'
require_relative 'event_group'
require_relative 'models'

class ModelScheduler
  def initialize(models,async)
      @models = models,
      @async=async,
      @username = get_user,
      @group = get_group,
      @pwd = get_pwd,
      @groups = event_group(models,async)
  end

  def event_group(models,async)
    EventGroup.new(models,async)
  end

  def run
    @groups.run
    @groups.get
  end
end