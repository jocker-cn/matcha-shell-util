# frozen_string_literal: true

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