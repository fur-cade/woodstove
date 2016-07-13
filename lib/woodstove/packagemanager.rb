# woodstove package manager - package commands for woodstove
# Copyright (c) 2016 the furry entertainment project
# Licensed under the MIT license.
require 'fileutils'
require 'yaml'

class WoodstovePackage
  def initialize name, directory, binpath
    @directory = directory
    @name = name
    @binpath = binpath
  end

  # Returns true if the package and kindling.yaml file exist.
  def is_package?
    File.exists? "#{@directory}/kindling.yaml"
  end

  # Returns true if the package directory exists.
  def is_installed?
    File.exists? "#{@directory}"
  end

  # Returns true if the package directory is a valid git repository.
  def is_repo?
    File.exists? "#{@directory}/.git"
  end

  # Returns the kindling.yaml data for this package.
  def kindling
    exit_with_error 'Missing kindlingfile.' if !is_package?
    YAML.load File.read("#{@directory}/kindling.yaml")
  end

  # Terminate the program, throwing the specified error.
  def exit_with_error error
    puts "Error managing #{@name} in #{@directory}: #{error}"
    exit 1
  end

  # Returns the git clone / github url for this package.
  def giturl
    "https://github.com/#{@name}"
  end

  # Runs a command inside the package directory.
  def exec_here command
    `cd "#{@directory}" && #{command}`
  end

  # Install this package by cloning it from github.
  def install branch
    if is_installed?
      exec_here "git init && git remote add origin \"#{giturl}\"" if !is_repo?
      exec_here "git pull --all"
    else
      `git clone -b #{branch} "#{giturl}" "#{@directory}"`
    end
    exec_here "git checkout #{branch}" if branch != false
    if is_package?
      install_dependencies
      install_bins
    end
  end

  # Removes this package.
  def remove
    exit_with_error "Packages must be installed to be removed." if !is_installed?
    remove_bins if is_package?
    FileUtils.rm_rf @directory
  end

  # Installs the dependencies for this package inside the `kindling` directory.
  def install_dependencies
    kf = kindling
    if kf['depends'] != nil
      kf['depends'].each do |package|
        install_package package, "#{@directory}/kindling", "#{@directory}/kindling/.bin"
      end
    end
    self
  end

  # Returns true if the specified script exists.
  def has_script? script
    kf = kindling
    kf['scripts'] && kf['scripts'][script]
  end

  # Puts the binaries for this package on the binpath.
  def install_bins
    kf = kindling
    if kf['bin'] != nil
      kf['bin'].each do |bin|
        # Create and make the script file executable.
        FileUtils.mkdir_p @binpath
        FileUtils.touch "#{@binpath}/#{bin[0]}"
        `chmod +x "#{@binpath}/#{bin[0]}"`

        # Insert a run command into the script file.
        File.open "#{@binpath}/#{bin[0]}", 'w' do |file|
          file.puts generate_run_command bin[1]
        end
      end
    end
    self
  end

  # Removes the binaries for this package from the binpath.
  def remove_bins
    kf = kindling
    if kf['bin'] != nil
      kf['bin'].each do |bin|
        FileUtils.rm "#{@binpath}/#{bin[0]}"
      end
    end
    self
  end

  # Installs dependencies for other package managers if present.
  def install_external_deps
    exec_here 'npm i' if File.exists? "#{@directory}/package.json"
    exec_here 'bundle install' if File.exists? "#{@directory}/Gemfile"
    self
  end

  # Returns a command to run the specified script file.
  def generate_run_command script
    exit_with_error "Trying to create run command for invalid script: #{script}" if !has_script? script
    kf = kindling
    scriptfile = kf['scripts'][script]
    fullpath = "\"#{@directory}/#{kf['scripts'][script]}\""
    case scriptfile.split('.')[-1]
    when 'rb'
      "ruby #{fullpath}"
    when 'sh'
      "bash #{fullpath}"
    when 'js'
      "node #{fullpath}"
    when 'py'
      "python #{fullpath}"
    else
      fullpath
    end
  end

  # Runs the specified script with the specified arguments.
  def run_script script, args
    exit_with_error "Trying to run invalid script: #{script}" if !has_script? script
    exec "#{generate_run_command script} #{args}"
  end
end

# Installs the given package into the specified directory.
def install_package package, directory, bindir
  branchget = package.split '@'
  name = branchget[0].split('/')[1]
  branch = branchget.length > 1 ? branchget[1] : false
  path = "#{directory}/#{name}"
  pkg = WoodstovePackage.new branchget[0], path, bindir
  pkg.install branch
  pkg
end

# Removes the given package from the specified directory.
def remove_package package, directory, bindir
  branchget = package.split '@'
  name = branchget[0].split('/')[1]
  path = "#{directory}/#{package}"
  pkg = WoodstovePackage.new branchget[0], path, bindir
  pkg.remove
  pkg
end

# Creates a package instance for the current working directory.
def current_package
  WoodstovePackage.new 'current package', FileUtils.pwd, global_kindling_bin
end

# Returns the global kindling directory.
def global_kindling
  if OS.mac?
    '~/Library/Application Support/woodstove'
  elsif OS.windows?
    'C:/ProgramData/woodstove/kindling'
  else
    '/usr/var/kindling'
  end
end

# Returns the global kindling bin directory.
def global_kindling_bin
  if OS.windows?
    'C:/ProgramData/woodstove/bin'
  else
    '/usr/local/bin'
  end
end

# Source: http://stackoverflow.com/questions/170956/how-can-i-find-which-operating-system-my-ruby-program-is-running-on
module OS
  def OS.windows?
    (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
  end

  def OS.mac?
   (/darwin/ =~ RUBY_PLATFORM) != nil
  end

  def OS.unix?
    !OS.windows?
  end

  def OS.linux?
    OS.unix? and not OS.mac?
  end
end
