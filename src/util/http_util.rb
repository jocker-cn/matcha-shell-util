# frozen_string_literal: true
require 'net/http'

require_relative 'constant'
require_relative '../support/result'
require_relative '../util/user_util'
require_relative '../util/logger_util'
HTTP_LOGGER = LoggerUtil.new("http")

def url_check(url)
  return Result.new(url, Result::ERROR, "请求路径不能为空") if url.length == 0
  uri = URI.parse(url)
  uri.is_a?(URI::HTTP) || url.is_a?(URI::HTTPS)
  Result.new(uri, Result::SUCCESS, "请求路径不能为空")
rescue URI::InvalidURIError => e
  return Result.new(url, Result::ERROR, e.message)
end

def re_download(url, file, mode = "wb")
  HTTP_LOGGER.info(file)
  uri = url_check(url)
  if uri.is_error
    return Result.new(file, Result::SUCCESS, "#{uri.error_obj}")
  end
  obj = uri.ok_obj
  success = false
  Net::HTTP.start(obj.host, obj.port, use_ssl: obj.scheme == "https") do |http|
    req = Net::HTTP::Get.new(url)
    http.request(req) do |response|
      if response.code == "200"
        open(file, mode) do |fi|
          response.read_body do |chunk|
            fi.write(chunk)
          end
          success = true
        end
      end
    end
  end
  if success
    return Result.new(file,Result::SUCCESS,"文件下载成功")
  end
   Result.new(file,Result::ERROR,"文件下载失败")
end