# frozen_string_literal: true
#
require_relative '../util/env_util'
require_relative '../util/logger_util'
require_relative '../util/constant'
require_relative '../util/http_util'
require_relative '../util/user_util'
require_relative '../util/file_util'
require_relative '../model/shell_executor'
require_relative '../model/DockerService'
require_relative './installer'

URL_PRE = "https://download.docker.com/linux/static/stable/"
ENV_KEY = "docker_version"
DEFAULT_VERSION = get_env_default(ENV_KEY, "23.0.1")
URL_POST = ".tgz"
CHUNK_FILE = get_pwd + "/docker-" + "%s" + URL_POST
INSTALL_DIR = get_pwd + "/docker"
INSTALL_FILES = INSTALL_DIR + "/** "
CHMOD_SHELL = ["+x ", INSTALL_FILES]
COPY_SHELL = [INSTALL_FILES, SYS_PATH::USR_BIN]
DOCKER_SERVICE_FILE = SYS_PATH::SYSTEMD_SYSTEMD + "/docker.service"
DOCKER_DAEMON_FILE = SYS_PATH::ETC_ + "/docker/daemon.json"
DOCKER_SOCKET_FILE = SYS_PATH::SYSTEMD_SYSTEMD + "/docker.socket"
CONTAINERD_FILE = SYS_PATH::SYSTEMD_SYSTEMD + "/containerd.service"
START_SHELL = SHELL::SYSTEMCTL_ + " start docker"
STOP_SHELL = SHELL::SYSTEMCTL_ + " stop docker"
ENABLE_SHELL = SHELL::SYSTEMCTL_ + " enable --now docker"

CONTAINER_START_SHELL = SHELL::SYSTEMCTL_ + " start containerd"
CONTAINER_STOP_SHELL = SHELL::SYSTEMCTL_ + " stop containerd"
CONTAINER_ENABLE_SHELL = SHELL::SYSTEMCTL_ + " enable --now containerd"

DOCKER_LOG = LoggerUtil.new("DOCKER")

class DockerInstaller
  include Installer

  def initialize(version, platform)
    @version = get_version(version)
    @platform = get_pf(platform)
    @url = URL_PRE + "#{@platform}" + "/docker-" + "#{@version}" + URL_POST
    @file = sprintf(CHUNK_FILE, "#{@version}")
    DOCKER_LOG.info("install, version: #{@version} platform: #{@platform} init...")
  end

  def download
    DOCKER_LOG.info("download url: #{@url} ...")
    re_download(@url, @file)
  end

  def install_pre
    unless is_installed
      DOCKER_LOG.info("docker already installed: skip")
      return false
    end

    result = download
    if result.is_ok
      if exec_shell(SHELL::TAR_, "-zxvf ", @file)
        if exec_shell(SHELL::CHMOD_, *CHMOD_SHELL)
          if exec_shell(SHELL::CP_, *COPY_SHELL)
            return true
          end
        end
      end
    else
      DOCKER_LOG.error("Installation package download fail: #{result.error_obj}")
    end
    false
  end

  def install
    if install_pre
      if install_file
        install_post
      end
    end
  end

  def is_installed
    no_app_check("docker") &&
      begin
        return `docker --version`.empty?
      rescue
        true
      end
  end

  def install_post
    start_docker
  end

  def start_docker
     exec_shell(ENABLE_SHELL) if exec_shell(START_SHELL) if exec_shell(CONTAINER_ENABLE_SHELL) if exec_shell(CONTAINER_START_SHELL) if exec_shell(SHELL::SYSTEMCTL_DAEMON)
  end

  def install_file
    file_write_batch({ DOCKER_DAEMON_FILE => DOCKER_DAEMON, DOCKER_SERVICE_FILE => DOCKER_SERVICE, CONTAINERD_FILE => CONTAINERD_SERVICE, DOCKER_SOCKET_FILE => DOCKER_SOCKET })
  end

  def exec_shell(shell, *args)
    executor = ShellExecutor.new(shell, *args)
    DOCKER_LOG.info("docker exec #{executor.shell}")
    executor.exec
    unless executor.is_success
      DOCKER_LOG.error("docker exec faile: #{executor.shell} #{executor.stderr}")
    end
    executor.is_success
  end

  def get_version(version)
    version == nil ? DEFAULT_VERSION : version
  end

  def get_pf(platform)
    if platform != nil && platform.length > 0
      pl = is_platform(platform)
      return pl if pl != nil
    end
    return X86_64 if is_x86_64
    return AARCH64 if is_aarch64
    return ARMEL if is_armel
    return ARMHF if is_armhf
    return PPC64LE if is_ppc64le
    S390X if is_s390x
  end

  def version
    @version
  end

  def platform
    @platform
  end

  private :install_file, :start_docker
end
