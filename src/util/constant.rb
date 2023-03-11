# frozen_string_literal: true
require_relative '../support/option_model'

F = '-f'
FILE = '--file'
FILE_DESC = '指定的文件名称(多个) [-f file1...] [--file file1...]'
H = '-h'
HELP = '--help'
HELP_DESC = '查看指定模块的文档'
KUBERNETES = 'K8S'
I = '-i'
INSTALL = '--install'
INSTALL_DESC = '查看可安装的服务  [-i list] [--install list]
                                     安装服务[多个] [-i k8s docker] [--install k8s harbor]'

HTTPS_C = "https"

class InstallOp
  include OptionModel

  def get_elem
    Array
  end

  def get_option
    I
  end

  def get_option_alisa
    INSTALL
  end

  def get_option_type
    OptionParser::REQUIRED_ARGUMENT
  end

  def help
    INSTALL_DESC
  end
end

class FileOp
  include OptionModel

  def get_elem
    Array
  end

  def get_option
    F
  end

  def get_option_alisa
    FILE
  end

  def get_option_type
    OptionParser::REQUIRED_ARGUMENT
  end

  def help
    FILE_DESC
  end
end

# OP_COLL=Set.new.add(FileOp.new).add(InstallOp.new)
OP_COLL_ARRAY = [FileOp.new]
OP_COLL_ONE_ARGS = [InstallOp.new]
OP_COLL_NO_ARGS = []

class SHELL
  CP_ = "/usr/bin/cp "
  SYSTEMCTL_ = "/usr/bin/systemctl "
  CHOWN_ = "/usr/bin/chown "
  CAT_ = "/usr/bin/cat "
  CHMOD_ = "/usr/bin/chmod "
  MAN_ = "/usr/bin/man "
  GREP_ = "/usr/bin/grep "
  SED_ = "/usr/bin/sed"
  TOUCH_ = "/usr/bin/touch "
  AWK_ = "/usr/bin/awk "
  READLINK_ = "/usr/bin/readlink "
  MKDIR_ = "/usr/bin/mkdir "
  TAR_ = "/usr/bin/tar "
end

class SYS_PATH
  USR_BIN = "/usr/bin"
  USR_LOCAL_BIN = "/usr/local/bin"
  SYSTEMD_SYSTEMD = "/etc/systemd/system"
  ETC_ = "/etc"
end


def is_install(k)
  return k == I || k == INSTALL
end