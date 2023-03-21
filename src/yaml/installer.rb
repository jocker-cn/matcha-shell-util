# frozen_string_literal: true

# 这个是支持安装的模块
# 暂时只支持docker
class Installer

end

class Docker
  def initialize(op = {})
    @ips = op[:ips]
    @version = op[:version]
    @platform = op[:platform]
  end
end