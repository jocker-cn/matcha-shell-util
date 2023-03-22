# frozen_string_literal: true
require 'yaml'

def yaml_file(src_file, &block)
  obj = YAML.load_file(src_file)
  obj = block.call(obj) if is_hash(obj)
  obj
end

def obj_to_yaml(obj)
  obj.to_yaml
end

def yaml_write(obj, src_file)
  File.write(src_file, obj.to_yaml)
end

def is_hash(yaml)
  yaml.is_a?(Hash)
end