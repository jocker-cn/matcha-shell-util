# frozen_string_literal: true

class Console

end

require 'open3'

# 执行命令
command = "ssh test1@192.168.112.129"

require 'pty'
require 'expect'

PTY.spawn(command) do |r, w, pid|
  if r.expect(/:/, 2) do |ma|
    puts ma
    if ma.to_s.match?(/fingerprint/)
      puts "yes"
      w.puts "yes"
    elsif ma.to_s.match?(/password:/)
      puts "123456"
      w.puts "123456"
    end
  end
  end
end
