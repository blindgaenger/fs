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
      FileUtils.rm_r(TEST_DIR) if File.exist?(TEST_DIR)
      FileUtils.mkdir_p(TEST_DIR)
      ::Dir.chdir(TEST_DIR)
    end
  end
end
include FS::SpecHelper

require 'fs'
