$LOAD_PATH.unshift(File.dirname(__FILE__)) unless $LOAD_PATH.include?(File.dirname(__FILE__))

require 'fileutils'
require 'etc'
require 'fs/base'

module FS
  extend self
  extend FS::Base
end
