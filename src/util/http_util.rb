# frozen_string_literal: true
require 'net/http'

require_relative 'constant'
require_relative '../support/result'

def url_check(url)
  return Result.new(url, Result::ERROR, "请求路径不能为空") if url.length == 0
  uri = URI.parse(url)
  uri.is_a?(URI::HTTP) || url.is_a?(URI::HTTPS)
  Result.new(uri, Result::SUCCESS, "请求路径不能为空")
rescue URI::InvalidURIError => e
  return Result.new(url, Result::ERROR, e.message)
end

def re_download(url, file, mode="wb")
  uri = url_check(url).ok_obj
  Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https") do |http|
    req = Net::HTTP::Get.new(url)
    http.request(req) do |response|
      open(file, mode) do |fi|
        response.read_body do |chunk|
          fi.write(chunk)
          return Result.new(file, Result::SUCCESS, "请求成功")
        end
      end if response.code == 200
      return Result.new(file, Result::ERROR, "请求失败")
    end
  end if uri != nil
end