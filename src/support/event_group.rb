# frozen_string_literal: true

class EventGroup
  def initialize

  end

end


OP={
SshResolve => SSHExecutor,
ScheduledResolve  => ScheduledExecutor,
InstallResolve  => InstallerExecutor,
YamlResolve  => YamlExecutor,
SupportResolve => SupportExecutor
}