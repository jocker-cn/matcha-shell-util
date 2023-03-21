# frozen_string_literal: true


#第一个版本不支持安装k8s
class K8s

  def initialize(op = {})
    @vip = op[:vip]
    @username = op[:username]
    @password = op[:password]
    # 私仓地址
    @repository = op[:repository]
    # 私仓用户名 如果你需要安装私仓 则此用户名会作为私仓用户名
    @rep_username=op[:rep_username]
    # 私仓密码  如果你需要安装私仓 则此密码会作为私仓用户名的密码
    @rep_password=op[:rep_password]

    #是否需要安装本地私仓
    #ins_pri_rep 如果为true 则pri_rep_ip，rep_username，rep_password为必选项
    @ins_pri_rep=op[:ins_pri_rep]
    @pri_rep_ip = op[:pri_rep_ip]


    @use_docker = op[:use_docker]
  end

end

class Roles
  def initialize(op = {})
    @role = op[:role]
    @ip = op[:ip]
    @hostname = op[:hostname]
    @username = op[:username]
  end
end
