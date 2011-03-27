require 'spec_helper'

describe FS do

  describe 'touch' do
    it 'touches a single file' do
      file = '/foobar.txt'
      FS.touch(file)
      File.exist?(file).should be_true 
    end
    
    it 'touches a list of files' do
      files = ['/foo.txt', '/bar.txt']
      FS.touch(files)
      files.each do |file|
        File.exist?(file).should be_true   
      end
    end
  end
  
  describe 'makedir' do
    it 'creates a dir' do
      FS.makedir('/foo')
      File.directory?('/foo').should be_true
    end
    
    it 'fails if a parent dir is missing' do
      lambda {FS.makedir('/foo/bar')}.should raise_error
    end
  end
  
  describe 'makedirs' do
    it 'creates all missing parent dirs' do
      FS.makedirs '/foo/bar/baz'
      File.directory?('/foo').should be_true
      File.directory?('/foo/bar').should be_true
      File.directory?('/foo/bar/baz').should be_true
    end
  end
  
  describe 'list' do
    it 'returns an empty list if there are no files' do
      FS.list('/').should be_empty
    end
    
    it 'lists all files and dirs (without . and ..)' do
      FS.touch('/foo')
      FS.makedir('/bar')
      FS.makedirs('/baz/lala')
      FS.list('/').should eql(['foo', 'bar', 'baz'])
      FS.list('/baz').should eql(['lala'])
    end
    
    it 'glob files for a pattern'
  end
  
  describe 'move' do
    it 'rename a file' do
      FS.touch('/foo.txt')
      FS.move('/foo.txt', '/bar.txt')
      FS.list('/').should eql(['bar.txt'])
    end
    
    # FIXME: fakefs
    # it 'moves a file' do
    #   FS.touch('/foo.txt')
    #   FS.makedirs('/tmp')
    #   FS.move('/foo.txt', '/tmp')
    #   FS.list('/').should eql(['tmp'])
    #   FS.list('/tmp').should eql(['foo.txt'])
    # end
    
    # TODO: use an array of sources
    # it 'moves files and dirs' do
    #   FS.touch('/file')
    #   FS.makedir('/dir')
    #   FS.makedir('/tmp')
    #   
    #   FS.move('/file', '/dir', '/tmp')
    #   
    #   FS.list('/').should eql(['tmp'])
    #   FS.list('/tmp').should eql(['file', 'dir'])
    # end
  end
  
  # describe 'currentdir'
  # describe 'changedir'
  # describe 'copy'
  # describe 'link'
  # describe 'write'
  # describe 'read'
  # describe 'remove'

end
