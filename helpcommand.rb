# woodstove helpcommand - help command for woodstove
# Copyright (c) 2016 the furry entertainment project
# Licensed under the MIT license.

class HelpCommand
  def initialize cmd
    @cmd = cmd
  end

  def long; 'help'; end
  def short; 'h'; end
  def opts; ''; end
  def info; 'Prints help information.'; end

  # Produce a formatted command string for the given command.
  def cmdify command
    optprefix = command.opts != '' ? ' ' + command.opts : ''
    "#{command.long}, #{command.short}#{optprefix}"
  end
  def run args
    usage

    # Get the length of the longest command string, so that we can pad the
    # information in the output.
    max_length = 0
    $argmanager.commands.each do |command|
      max_length = [max_length, cmdify(command[1]).length].max
    end

    # Print each command's information, with padding after the command string.
    puts "\nOptions:"
    $argmanager.commands.each do |command|
      padded = "%-#{max_length}s" % cmdify(command[1])
      puts "  #{padded} - #{command[1].info}"
    end
  end
  def usage
    puts "Usage: #{@cmd} [command] [options]"
  end
  def incorrect_usage
    usage
    puts "For more information: `#{@cmd} help`"
  end
end
$argmanager.register :help, HelpCommand.new('woodstove')
