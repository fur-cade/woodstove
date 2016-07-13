# woodstove packagecommands - package commands for woodstove
# Copyright (c) 2016 the furry entertainment project
# Licensed under the MIT license.

require 'woodstove/packagemanager'
require 'fileutils'

# Prints the error and terminates the program if the args array is empty.
def need_args args, error
  if args.length < 1
    puts error
    exit 1
  end
end

class InstallCommand
  def long; 'install'; end
  def short; 'i'; end
  def opts; '[packages]'; end
  def info; 'Install specified packages.'; end

  def run packages
    if packages.length < 1
      current_package
        .install_dependencies
        .install_bins
    end
    packages.each do |package|
      install_package package, "#{FileUtils.pwd}/kindling", "#{FileUtils.pwd}/kindling/.bin"
    end
  end
end
$argmanager.register :install, InstallCommand.new

class RemoveCommand
  def long; 'remove'; end
  def short; 'r'; end
  def opts; '[packages]'; end
  def info; 'Remove specified packages.'; end

  def run packages
    need_args packages, 'You must specify packages to remove.'
    packages.each do |package|
      remove_package package, "#{FileUtils.pwd}/kindling", "#{FileUtils.pwd}/kindling/.bin"
    end
  end
end
$argmanager.register :remove, RemoveCommand.new

class InstallGlobalCommand
  def long; 'install-global'; end
  def short; 'ig'; end
  def opts; '[packages]'; end
  def info; 'Install specified packages globally.'; end

  def run packages
    need_args packages, 'You must specify packages to install globally.'
    packages.each do |package|
      install_package package, global_kindling, global_kindling_bin
    end
  end
end
$argmanager.register :installglobal, InstallGlobalCommand.new

class RemoveGlobalCommand
  def long; 'remove-global'; end
  def short; 'rg'; end
  def opts; '[packages]'; end
  def info; 'Remove specified packages globally.'; end

  def run packages
    need_args packages, 'You must specify packages to remove globally.'
    packages.each do |package|
      remove_package package, global_kindling, global_kindling_bin
    end
  end
end
$argmanager.register :removeglobal, RemoveGlobalCommand.new

class StartCommand
  def long; 'start'; end
  def short; 's'; end
  def opts; '[args]'; end
  def info; 'Runs `main` script for current package.'; end

  def run args
    current_package.run_script 'main', args.join(' ')
  end
end
$argmanager.register :start, StartCommand.new

class ExecCommand
  def long; 'exec'; end
  def short; 'x'; end
  def opts; '[script] [args]'; end
  def info; 'Runs specified script for current package.'; end

  def run args
    need_args args, 'You must specify a script to execute.'
    current_package.run_script args[0], args[1..-1].join(' ')
  end
end
$argmanager.register :exec, ExecCommand.new
