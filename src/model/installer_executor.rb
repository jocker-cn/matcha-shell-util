# frozen_string_literal: true
require_relative 'docker_executor'
require_relative 'harbor_executor'
require_relative 'kub_executor'
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

class InstallerExecutor < ExecutorOpt
  def initialize(models)
    super(models)
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

