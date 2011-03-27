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
      FS.list('/').should eql(['foo', 'bar'])
    end
    
    it 'globs files and dirs' do
      FS.touch('/file.txt')
      FS.touch('/file.rb')
      FS.makedir('/dir.txt')
      FS.makedir('/dir.rb')
      FS.list('/', '*.txt').should eql(['file.txt', 'dir.txt'])
    end
    
    it 'lists files and dirs in a subdir' do
      FS.makedir('/foo')
      FS.makedir('/foo/dir')
      FS.touch('/foo/file')
      FS.list('/foo').should eql(['dir', 'file'])
    end
    
    it 'globs files and dirs in a subdir' do
      FS.makedir('/foo')
      FS.touch('/foo/file.txt')
      FS.touch('/foo/file.rb')
      FS.makedir('/foo/dir.txt')
      FS.makedir('/foo/dir.rb')
      FS.list('/foo', '*.txt').should eql(['dir.txt', 'file.txt'])
    end
  end
  
  describe 'find' do
    it 'returns an empty list if there are no files' do
      FS.list('/').should be_empty
    end
    
    it 'finds files in all subdirs' do
      FS.makedirs('/one/two/three')
      FS.touch('/one/file.one')
      FS.touch('/one/two/three/file.three')
      FS.find('/').should eql([
        'one',
        'one/file.one',
        'one/two',
        'one/two/three',
        'one/two/three/file.three'
      ])
    end
    
    it 'globs files in all subdirs' do
      FS.makedirs('/one/two/three')
      FS.touch('/one/file.one')
      FS.touch('/one/two/three/file.three')
      FS.find('/', 'file.*').should eql([
        'one/file.one',
        'one/two/three/file.three'
      ])
    end
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
    
    # FIXME: fakefs
    # it 'moves files and dirs' do
    #   FS.touch('/file')
    #   FS.makedir('/dir')
    #   FS.makedir('/tmp')
    #   FS.move('/file', '/dir', '/tmp')
    #   FS.list('/').should eql(['tmp'])
    #   FS.list('/tmp').should eql(['file', 'dir'])
    # end
  end

  describe 'remove' do
    it 'removes files and dirs' do
      FS.touch('/file')
      FS.makedir('/dir')
      FS.remove('/file', '/dir')
      FS.list('/').should be_empty
    end

    # FIXME: fakefs
    # it 'fails if the dir is not empty' do
    #   FS.makedir('/foo')
    #   FS.touch('/foo/bar')
    #   lambda {FS.remove('/foo')}.should raise_error
    # end
  end

  describe 'write' do
    it 'writes content from a string' do
      FS.write('/foo.txt', 'bar')
      File.open('/foo.txt').read.should eql('bar')
    end
    
    it 'writes content from a block' do
      FS.write('/foo.txt') {|f| f.write 'bar' }
      File.open('/foo.txt').read.should eql('bar')
    end
  end
  
  describe 'read' do
    it 'reads the content to a string' do
      File.open('/foo.txt', 'w') {|f| f.write 'bar' }
      FS.read('/foo.txt').should eql('bar')
    end
    
    it 'reads the content to a block' do
      File.open('/foo.txt', 'w') {|f| f.write 'bar' }
      FS.read('/foo.txt') {|f| f.read.should eql('bar')}
    end
  end
  
  describe 'root' do
    it 'always returns /' do
      FS.root.should eql('/')
    end
  end

  describe 'home' do
    it 'returns the home of the current user' do
      FS.home.should eql('/Users/me')
    end
    
    it 'returns the home of another user' do
      FS.home('you').should eql('/Users/you')
    end
  end
  
  # describe 'removedir'
  # describe 'removedirs'
  # describe 'currentdir'
  # describe 'changedir'
  # describe 'copy'
  # describe 'link'

end
