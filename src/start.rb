# frozen_string_literal: true
#!/usr/bin/ruby -w
# -*- coding: UTF-8 -*-

require 'optparse'
require_relative './util/constant'
require_relative './util/logger_util'
require_relative './support/support'

LOGGER_START ||= LoggerUtil.new("start")

options = {}
OptionParser.new do |opts|
  OP_COLL_ARRAY.each { |k|
    opk = k.get_option
    opts.on(opk, k.get_option_alisa, k.get_elem, k.get_option_type, k.help) do |files|
      options["#{opk}"] = files
      options["#{opk}"] += ARGV.take_while { |arg| arg !~ /^-/ }
    end
  }

  OP_COLL_ONE_ARGS.each { |k|
    opk = k.get_option
    opts.on(opk, k.get_option_alisa, k.get_elem, k.get_option_type, k.help) do |files|
      options["#{opk}"] = files
      options["#{opk}"] += ARGV.take_while { |arg| arg !~ /^-/ } if k.get_elem.class == Array.class
    end
  }

  OP_COLL_NO_ARGS.each { |k|
    opk = k.get_option
    opts.on(opk, k.get_option_alisa, k.get_elem, k.get_option_type, k.help) do |files|
      options["#{opk}"] = files
    end
  }
end.parse!

class Start
  def run(options)
    LOGGER_START.info_model("matcha", "shell", "start")
    LOGGER_START.info_model("matcha", "request", options.to_s)
    Support.new(options).call
  end
end

# Start.new.run(options)

require 'yaml'

# 要保存为YAML文件的Ruby对象

class Test

  attr_accessor :name, :age

  def initialize(name, age)
    @name = name
    @age = age
  end

  def yaml_initialize(tag, properties)
    @name = properties[:name]
    @age = properties[:age]
  end

end

class Person
  attr_accessor :name, :age, :test

  def initialize(name, age, test)
    @name = name
    @age = age
    @test = test
  end
end

require_relative './util/yaml_util'
# p = Person.new("person",20,Test.new("test",20))

# File.write("example.yml",p.to_yaml)
# 从YAML文件加载自定义类对象
# person = YAML.load_file("example.yml")
person = yaml_file("example.yml") do |obj|
  test = obj["Person"]["test"]
  puts test
  Person.new(obj["Person"]["name"], obj["Person"]["age"], Test.new(test["name"], test["age"]))
end

