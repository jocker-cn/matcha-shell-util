# frozen_string_literal: true

class SHELL
  CP_ = "/usr/bin/cp "
  SYSTEMCTL_ = "/usr/bin/systemctl "
  SYSTEMCTL_DAEMON = "/usr/bin/systemctl daemon-reload"
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