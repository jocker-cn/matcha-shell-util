# frozen_string_literal: true

require_relative 'harbor_executor'

require_relative 'shell_executor'

INSTALL_MODEL =
  {
    "docker" => DockerExecutor,
    "harbor" => HarborExecutor,
    "k8s" => KubExecutor,
    "ansible" => ShellExecutor,
    "nginx" => ShellExecutor,
    "keepalived" => ShellExecutor,
    "redis" => ShellExecutor,
    "mysql" => ShellExecutor,
    "java" => ShellExecutor,
  }

class InstallerExecutor
  include Executors

  def initialize(obj)

  end

  def exec
    super
  end

  def model
    super
  end

  def args
    super
  end
end

