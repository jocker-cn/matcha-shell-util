# frozen_string_literal: true
require_relative '../util/constant'

MODEL_ORDER = {
  "docker" => 100,
  "harbor" => 50,
  "k8s" => 40,
  "ansible" => 120,
  "nginx" => 130,
  "keepalived" => 150,
  "redis" => 20,
  "mysql" => 20,
  "java" => 30,
}

class Models
  attr_reader :desc, :model, :args

  def initialize(model, args)
    @desc=MODEL_NAME[model]
    @model = model
    @args = args
    @obj=yaml_file(model,args)
  end

end

#根据当前请求的模块 解析yml文件
def yaml_file(model,args)

end

def order(k)
  if k == nil || !is_install(k)
    return 0
  end
  v = MODEL_ORDER[k]
  0 if v == nil
end