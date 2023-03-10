# frozen_string_literal: true

def get_pwd
  Dir.pwd
end

def get_user
  Etc.getpwuid(Process.uid).freeze
end

def get_group
  Etc.getgrgid(Process.gid).freeze
end
