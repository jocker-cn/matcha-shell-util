# frozen_string_literal: true

require_relative 'executors'
require 'open3'

class ShellExecutor
  include Executors

  def initialize(shell, *args)
    args.each { |k| shell += (" " + k) }
    @shell = shell
    @args = args
  end

  def exec
    @stdout, @stderr, @status = Open3.capture3(@shell)
  end

  def status
    puts @status
  end

  def is_success
    @status.to_s.end_with?("0")
  end

  def stdout
    @stdout
  end
end