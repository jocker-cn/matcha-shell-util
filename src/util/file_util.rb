# frozen_string_literal: true
require 'fileutils'
require_relative './logger_util'

FILE_LOGGER = LoggerUtil.new("file")

def is_file(file)
  file != nil && File.file?(file)
end

def is_dir(file)
  File.directory?(file)
end

def append_context_file(file, c: String)
  if is_file(file)
    File.open(file, 'a') do |f|
      f << c
    end.close
  end
end

def create_file(file, c: String)
  if is_file(file)
    File.open(file, 'a') do |f|
      f << c
    end.close
  end
end

def copy_files(src_dir, dst_dir, file_permissions)
  FileUtils.mkdir_p(dst_dir)

  Dir.glob(src_dir)
  if is_file(dst_dir)
    destination_file = File.join(dst_dir, File.basename(src_dir))
    begin
      FileUtils.copy(src_dir, destination_file)
      FileUtils.chmod(file_permissions, destination_file) if file_permissions != nil
    rescue Exception => e
      FILE_LOGGER.error("file copy fail: #{e.message}")
      FileUtils.remove_file(destination_file) if is_file(destination_file)
      FileUtils.remove_dir(destination_file) if is_dir(destination_file)
      nil
    end
  end
end

def copy_single_file(src_file, dst_dir, file_permissions)
  FileUtils.mkdir_p(dst_dir)
  if is_file(src_file)
    destination_file = File.join(dst_dir, File.basename(src_file))
    begin
      FileUtils.copy(src_file, destination_file)
      FileUtils.chmod(file_permissions, destination_file) if file_permissions != nil
    rescue Exception => e
      FILE_LOGGER.error("file copy fail: #{e.message}")
      FileUtils.remove_file(destination_file) if is_file(destination_file)
      FileUtils.remove_dir(destination_file) if is_dir(destination_file)
      nil
    end
  end
end

def move_single_file(src_file, dst_dir, file_permissions)
  FileUtils.mkdir_p(dst_dir)
  destination_file = File.join(dst_dir, File.basename(src_file))
  begin
    FileUtils.move(src_file, destination_file)
    FileUtils.chmod(file_permissions, destination_file) if file_permissions != nil
  rescue Exception => e
    FILE_LOGGER.error("file move fail: #{e.message}")
    FileUtils.remove_file(destination_file) if is_file(destination_file)
    FileUtils.remove_dir(destination_file) if is_dir(destination_file)
    return
  end
end

def file_write(context, src_file, encoding = "UTF-8")
  dir_pre = File.dirname(src_file)
  FileUtils.mkdir_p(dir_pre) unless dir_pre.eql?(".")
  FileUtils.touch(src_file)
  File.open(src_file, 'w', encoding: encoding) do |file|
    file.write(context) if context.length > 0
  end
end

def file_write_batch(map, encoding = "UTF-8")
  map.each do |k, v|
    FILE_LOGGER.info("create file: #{v}")
    write_bytes = file_write(v, k, encoding)
    if write_bytes == nil || write_bytes < v.length
      FILE_LOGGER.error("create fail: #{v}")
      return false
    end
  end
  true
end

