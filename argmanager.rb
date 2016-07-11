# woodstove argmanager - a simple argument manager for woodstove
# Copyright (c) 2016 the furry entertainment project
# Licensed under the MIT license.
class ArgManager
  def initialize
    @commands = {}
  end
  def run
    @commands.each do |command|
      if ARGV[0] == command[1].long || ARGV[0] == command[1].short
        command[1].run ARGV[1..-1]
        return
      end
    end
    if @commands[:help]
      @commands[:help].incorrect_usage
      exit 1
    end
  end
  def register key, command
    @commands[key] = command
  end
  def commands
    @commands
  end
end
$argmanager = ArgManager.new
