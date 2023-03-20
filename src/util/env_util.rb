# frozen_string_literal: true
require 'socket'

WINDOWS = "i386-mingw32"
MACOS = "x86_64-darwin19"
LINUX = "x86_64-linux"
X86_64 = "x86_64"
AARCH64 = "aarch64"
ARM64 = "arm64"
ARMEL = "armel"
ARMHF = "armhf"
PPC64LE = "ppc64le"
S390X = "s390x"

# 获取环境变量
def get_env(a: String)
  ENV[a]
end

def get_env_default(a, default)
  ENV[a] == nil ? default : ENV[a]
end

def set_env_map(map: Hash)
  map.each do |k, v|
    set_env(k: k, v: v)
  end
end

def set_env(k: String, v: String)
  ENV[k] = v
end

def is_windows
  RUBY_PLATFORM.eql?(WINDOWS)
end

def is_macos
  RUBY_PLATFORM.eql?(MACOS)
end

def is_linux
  RUBY_PLATFORM.eql?(LINUX)
end

def is_x86_64
  RbConfig::CONFIG['host_cpu'].include?(X86_64)
end

def is_aarch64
  RbConfig::CONFIG['host_cpu'].include?(AARCH64) || RbConfig::CONFIG['host_cpu'].include?(ARM64)
end

def is_armel
  RbConfig::CONFIG['host_cpu'].include?(ARMEL)
end

def is_armhf
  RbConfig::CONFIG['host_cpu'].include?(ARMHF)
end

def is_ppc64le
  RbConfig::CONFIG['host_cpu'].include?(PPC64LE)
end

def is_s390x
  RbConfig::CONFIG['host_cpu'].include?(S390X)
end

def is_platform(platform)
  X86_64 if X86_64.include?(platform)
  AARCH64 if AARCH64.include?(platform)
  ARMEL if ARMEL.include?(platform)
  ARMHF if ARMHF.include?(platform)
  PPC64LE if PPC64LE.include?(platform)
  S390X if S390X.include?(platform)
  nil
end

def is_local_ip(ip)
  if ip.eql?("localhost") || ip.eql?("127.0.0.1") || ip.eql?(local_ip(nil))
    true
  end
  false
end

def local_ip(network_name)
  # 获取当前机器正在使用的网卡信息
  if_addrs = Socket.getifaddrs.select { |if_addr| if_addr.addr&.ipv4? && !if_addr.flags & Socket::IFF_LOOPBACK != 0 }

  # 获取正在使用的网卡的 IP 地址
  if network_name == nil
    ip = if_addrs.find { |if_addr| (if_addr.flags & Socket::IFF_UP != 0) && if_addr.addr.ip_address != "127.0.0.1" }
  else
    ip = if_addrs.find { |if_addr| (if_addr.flags & Socket::IFF_UP != 0) && if_addr.addr.ip_address != "127.0.0.1" && if_addr.name == network_name }
  end

  # 返回 IP 地址
  ip.addr.ip_address if ip
end

def no_app_check(app)
  false if app == nil
  qa = "rpm -qa | grep #{app}"
  result = `#{qa}`
  result.empty?
end