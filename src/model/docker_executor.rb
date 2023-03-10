# frozen_string_literal: true

require_relative '../util/env_util'
require_relative '../util/constant'
require_relative '../util/http_util'
require_relative '../util/user_util'
require_relative '../util/file_util'
require_relative 'shell_executor'
require_relative 'DockerService'
URL_PRE = "https://download.docker.com/linux/static/stable/"
ENV_KEY = "docker_version"
DEFAULT_VERSION = get_env_default(ENV_KEY, "23.0.1")
URL_POST = ".tgz"
CHUNK_FILE = get_pwd + "/" + DEFAULT_VERSION + URL_POST
INSTALL_DIR = get_pwd + "/docker"
INSTALL_FILES = INSTALL_DIR + "/** "
CHMOD_SHELL = ["+x ", INSTALL_FILES]
COPY_SHELL = [INSTALL_FILES, SYS_PATH::USR_BIN]
DOCKER_SERVICE_FILE = SYS_PATH::SYSTEMD_SYSTEMD + "/docker.service"
DOCKER_SOCKET_FILE = SYS_PATH::SYSTEMD_SYSTEMD + "/docker.socket"
CONTAINERD_FILE = SYS_PATH::SYSTEMD_SYSTEMD + "/containerd.service"

class DockerExecutor

end

class Install
  def initialize(version, platform)
    @version = get_version(version)
    @platform = get_pf(platform)
    @url = URL_PRE + @platform + "/" + @version + URL_POST
    @file = CHUNK_FILE
  end

  def download
    result = re_download(@url, @file, nil)
    install if result.is_ok
  end

  def install
    if exec_shell(SHELL::TAR_, " -xvf ", @file)
      if exec_shell(SHELL::CHMOD_, CHMOD_SHELL)
        if exec_shell(SHELL::CP_, COPY_SHELL)

        end
      end
    end

    def version
      @version
    end

    def platform
      @platform
    end
  end

  def install_file
    file_write_batch({ DOCKER_SERVICE_FILE => DOCKER_SERVICE, CONTAINERD_FILE => CONTAINERD_SERVICE, DOCKER_SOCKET_FILE => DOCKER_SOCKET })
  end

  def exec_shell(shell, *args)
    executor = ShellExecutor.new(shell, args)
    executor.exec
    executor.is_success
  end

  def get_version(version)
    if version == nil ? DEFAULT_VERSION : version
    end

    def get_pf(platform)
      if platform != nil && platform.length > 0
        pl = is_platform(platform)
        return pl if pl != nil
      end
      X86_64 if is_x86_64
      AARCH64 if is_aarch64
      ARMEL if is_armel
      ARMHF if is_armhf
      PPC64LE if is_ppc64le
      S390X if is_s390x
    end
  end
end
