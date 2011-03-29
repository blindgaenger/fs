$LOAD_PATH.unshift(File.dirname(__FILE__)) unless $LOAD_PATH.include?(File.dirname(__FILE__))

require 'fileutils'
require 'etc'
require 'fs/base'
require 'fs/alias'

module FS
  include FS::Base
  include FS::Alias
  extend self
end
