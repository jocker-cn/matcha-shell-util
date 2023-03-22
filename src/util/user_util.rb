# frozen_string_literal: true
require 'etc'

def get_pwd
  Dir.pwd
end

def get_user
  Etc.getpwuid(Process.uid).name
end

def get_group
  Etc.getgrgid(Process.gid).name
end