module FS
  module SpecHelpers

    def self.extended(example_group)
      example_group.use_helper(example_group)
    end

    def self.included(example_group)
      example_group.extend self
    end

    def use_helper(describe_block)
      describe_block.before :each do
        unless @test_dir
          @test_dir = File.realpath(Dir.mktmpdir('test_'))
          Dir.chdir(@test_dir)
        end
      end

      describe_block.after :each do
        if @test_dir
          FileUtils.rm_r(@test_dir)
          @test_dir = nil
        end
      end
    end

  end
end

RSpec.configure do |config|
  config.include FS::SpecHelpers
end
