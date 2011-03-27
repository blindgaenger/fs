require 'fakefs/spec_helpers'

RSpec.configure do |config|
  config.include FakeFS::SpecHelpers
end

# FileUtils.mkdir is not handled
# https://github.com/defunkt/fakefs/issues/closed#issue/37
#
# Patch:
# https://github.com/flavio/fakefs/blob/ea22773bc293ea3bce97317086b8171669780eab/lib/fakefs/fileutils.rb
module FakeFS
  module FileUtils
    extend self
    def mkdir(path)
      parent = path.split('/')
      parent.pop
      raise Errno::ENOENT, "No such file or directory - #{path}" unless parent.join == "" || FileSystem.find(parent.join('/'))
      raise Errno::EEXIST, "File exists - #{path}" if FileSystem.find(path)
      FileSystem.add(path, FakeDir.new)
    end
  end
end


module FakeFS
  class Dir
    def self.home(user=nil)
      "/Users/#{user || 'me'}"
    end
  end
end