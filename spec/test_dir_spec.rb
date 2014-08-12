require_relative 'spec_helper'

describe FS do
  before { reset_fs }

  describe 'test dir' do
    it 'is absolute' do
      Pathname.new(TEST_DIR).absolute?.must_equal true
    end

    it 'is created' do
      File.exist?(TEST_DIR).must_equal true
    end

    it 'is a directory' do
      File.directory?(TEST_DIR).must_equal true
    end

    it 'is empty' do
      Dir.entries(TEST_DIR).must_equal ['.', '..']
    end

    it 'is the current dir' do
      File.expand_path(Dir.pwd).must_equal(TEST_DIR)
    end

    it 'is deleted when not empty' do
      filename = 'test.file'
      FileUtils.touch(filename)
      File.exist?(File.join(TEST_DIR, filename)).must_equal true
    end
  end
end