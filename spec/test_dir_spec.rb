require 'spec_helper'

describe FS do
  describe 'test dir' do
    it 'is absolute' do
      Pathname.new(@test_dir).should be_absolute
    end
    
    it 'is created' do
      File.exist?(@test_dir).should be_true
    end
    
    it 'is a directory' do
      File.directory?(@test_dir).should be_true
    end
    
    it 'is empty' do
      Dir.entries(@test_dir).should eql([".", ".."])
    end
    
    it 'is the current dir' do
      File.expand_path(Dir.pwd).should eql(@test_dir)
    end
    
    it 'is deleted when not empty' do
      filename = 'test.file'
      FileUtils.touch(filename)
      File.exist?(File.join(@test_dir, filename)).should be_true
    end
  end
end