# frozen_string_literal: true
require 'yaml'

def yaml_file(src_file, &block)
  obj = YAML.load_file(src_file)
  return obj if is_ruby_yaml(obj)
  block.call(obj)
end

def obj_to_yaml(obj)
  obj.to_yaml
end

def yaml_write(obj, src_file)
  File.write(src_file, obj.to_yaml)
end

def is_ruby_yaml(yaml)
  yaml.to_s.include?("!ruby/object:Test")
end