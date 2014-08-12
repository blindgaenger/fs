ENV['RACK_ENV'] = 'test'

require 'minitest/spec'
require 'minitest/autorun'
module MiniTest
  class Spec
    class << self
      alias_method :context, :describe
    end
  end
end

module FS
  module SpecHelper
    TEST_DIR = File.expand_path '../../tmp/workspace', __FILE__

    def reset_fs
      FS.removedirs(TEST_DIR) if FS.exist?(TEST_DIR)
      FS.makedirs(TEST_DIR)
      FS.changedir(TEST_DIR)
    end
  end
end
include FS::SpecHelper

require 'fs'
