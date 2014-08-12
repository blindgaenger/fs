$LOAD_PATH.unshift(File.dirname(__FILE__)) unless $LOAD_PATH.include?(File.dirname(__FILE__))

require 'fileutils'
require 'etc'
require 'tmpdir'
require 'find'

require 'fs/old'
require 'fs/dir'
require 'fs/find'
require 'fs/tree'
require 'fs/alias'

module FS
  include FS::Old
  include FS::Dir
  include FS::Find
  include FS::Tree
  include FS::Alias
  extend self
end
