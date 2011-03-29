require 'spec_helper'

describe FS::Base do
  
  describe 'touch' do
    it 'touches a single file' do
      file = 'foobar.txt'
      FS.touch(file)
      File.exist?(file).should be_true 
    end
    
    it 'accepts multiple files' do
      FS.touch('foo.txt', 'bar.txt')
      File.exist?('foo.txt').should be_true
      File.exist?('bar.txt').should be_true
    end
    
    it 'accepts a list of files' do
      files = ['foo.txt', 'bar.txt']
      FS.touch(files)
      files.each do |file|
        File.exist?(file).should be_true   
      end
    end
  end
  
  describe 'makedir' do
    it 'creates a dir' do
      FS.makedir('foo')
      File.directory?('foo').should be_true
    end
    
    it 'accepts multiple dirs' do
      FS.makedir('foo', 'bar')
      File.directory?('foo').should be_true
      File.directory?('bar').should be_true
    end
    
    it 'fails if a parent dir is missing' do
      lambda {FS.makedir('foo/bar')}.should raise_error
    end
  end
  
  describe 'makedirs' do
    it 'creates all missing parent dirs' do
      FS.makedirs 'foo/bar/baz'
      File.directory?('foo').should be_true
      File.directory?('foo/bar').should be_true
      File.directory?('foo/bar/baz').should be_true
    end
    
    it 'accepts multiple dirs' do
      FS.makedirs('foo/bar', 'baz/yep')
      File.directory?('foo').should be_true
      File.directory?('foo/bar').should be_true
      File.directory?('baz').should be_true
      File.directory?('baz/yep').should be_true
    end
  end
  
  describe 'removedir' do
    it 'removes a dir' do
      FS.makedir('foo')
      FS.removedir('foo')
      File.exist?('foo').should be_false
    end
    
    it 'fails if dir not empty' do
      FS.makedirs('foo/dir')
      FS.touch('foo/file')
      lambda {FS.removedir('foo')}.should raise_error
    end
  end
  
  describe 'removedirs' do
    it 'removes a dir' do
      FS.makedir('foo')
      FS.removedirs('foo')
      File.exist?('foo').should be_false
    end
    
    it 'removes a dir even if something is inside' do
      FS.makedirs('foo/dir')
      FS.touch('foo/file')
      FS.removedirs('foo')
      File.exist?('foo').should be_false
    end
  end
  
  describe 'list' do
    it 'returns an empty list if there are no files' do
      FS.list.should be_empty
    end
    
    it 'lists all files and dirs (without . and ..)' do
      FS.touch('file')
      FS.makedir('dir')
      FS.list.should eql(['dir', 'file'])
    end
    
    it 'lists files and dirs in the current dir' do
      FS.makedir('foo')
      FS.makedir('foo/dir')
      FS.touch('foo/file')
      Dir.chdir('foo')
      FS.list.should eql(['dir', 'file'])
    end
    
    it 'globs files and dirs' do
      FS.touch('file.txt')
      FS.touch('file.rb')
      FS.makedir('dir.txt')
      FS.makedir('dir.rb')
      FS.list('.', '*.txt').should eql(['dir.txt', 'file.txt'])
    end
    
    it 'globs files and dirs' do
      FS.touch('file.txt')
      FS.touch('file.rb')
      FS.makedir('dir.txt')
      FS.makedir('dir.rb')
      FS.list('.', '*.txt').should eql(['dir.txt', 'file.txt'])
    end
  
    it 'lists files and dirs in a subdir' do
      FS.makedir('foo')
      FS.makedir('foo/dir')
      FS.touch('foo/file')
      FS.list('foo').should eql(['dir', 'file'])
    end
    
    it 'globs files and dirs in a subdir' do
      FS.makedir('foo')
      FS.touch('foo/file.txt')
      FS.touch('foo/file.rb')
      FS.makedir('foo/dir.txt')
      FS.makedir('foo/dir.rb')
      FS.list('foo', '*.txt').should eql(['dir.txt', 'file.txt'])
    end
  end
  
  describe 'find' do
    it 'returns an empty list if there are no files' do
      FS.find('.').should be_empty
    end
    
    it 'finds files in all subdirs' do
      FS.makedirs('one/two/three')
      FS.touch('one/file.one')
      FS.touch('one/two/three/file.three')
      FS.find.should eql([
        'one',
        'one/file.one',
        'one/two',
        'one/two/three',
        'one/two/three/file.three'
      ])
    end
    
    it 'globs files in all subdirs' do
      FS.makedirs('one/two/three')
      FS.touch('one/file.one')
      FS.touch('one/two/three/file.three')
      FS.find('.', 'file.*').should eql([
        'one/file.one',
        'one/two/three/file.three'
      ])
    end
  end
  
  describe 'move' do
    it 'renames a file' do
      FS.touch('foo.txt')
      FS.move('foo.txt', 'bar.txt')
      FS.list.should eql(['bar.txt'])
    end
    
    it 'moves a file' do
      FS.touch('foo.txt')
      FS.makedirs('tmp')
      FS.move('foo.txt', 'tmp')
      FS.list.should eql(['tmp'])
      FS.list('tmp').should eql(['foo.txt'])
    end
    
    it 'moves files and dirs' do
      FS.touch('file')
      FS.makedir('dir')
      FS.makedir('tmp')
      FS.move('file', 'dir', 'tmp')
      FS.list.should eql(['tmp'])
      FS.list('tmp').should eql(['dir', 'file'])
    end
  end
  
  describe 'copy' do
    it 'copies a file' do
      FS.write('foo.txt', 'lala')
      FS.copy('foo.txt', 'bar.txt')
      File.exist?('foo.txt').should be_true
      File.exist?('bar.txt').should be_true
    end

    it 'copies the content' do
      FS.write('foo.txt', 'lala')
      FS.copy('foo.txt', 'bar.txt')
      FS.read('foo.txt').should eql('lala')
      FS.read('bar.txt').should eql('lala')
    end
    
    it 'copies a file to a dir' do
      FS.write('foo.txt', 'lala')
      FS.makedir('dir')
      FS.copy('foo.txt', 'dir/bar.txt')
      File.exist?('foo.txt').should be_true
      File.exist?('dir/bar.txt').should be_true
    end
  end
  
  describe 'link' do
    it 'links to files' do
      FS.touch('foo.txt')
      FS.link('foo.txt', 'bar.txt')
      FS.write('foo.txt', 'lala')
      FS.read('bar.txt').should eql('lala')
    end
    
    it 'links to dirs' do
      FS.makedir('foo')
      FS.link('foo', 'bar')
      FS.touch('foo/file')
      FS.list('bar').should eql(['file'])
    end
  end
  
  describe 'remove' do
    it 'removes files' do
      FS.touch('file')
      FS.remove('file')
      FS.list.should be_empty
    end

    it 'removes multiple files' do
      FS.touch('file.a')
      FS.touch('file.b')
      FS.remove('file.a', 'file.b')
      FS.list.should be_empty
    end
    
    it 'fails on dirs' do
      FS.makedir('dir')
      lambda {FS.remove('dir')}.should raise_error
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
      FS.write('foo.txt', 'bar')
      File.open('foo.txt').read.should eql('bar')
    end
    
    it 'writes content from a block' do
      FS.write('foo.txt') {|f| f.write 'bar' }
      File.open('foo.txt').read.should eql('bar')
    end
  end
  
  describe 'read' do
    it 'reads the content to a string' do
      File.open('foo.txt', 'w') {|f| f.write 'bar' }
      FS.read('foo.txt').should eql('bar')
    end
    
    it 'reads the content to a block' do
      File.open('foo.txt', 'w') {|f| f.write 'bar' }
      FS.read('foo.txt') {|f| f.read.should eql('bar')}
    end
  end
  
  describe 'root' do
    it 'always returns /' do
      FS.root.should eql('/')
    end
  end
  
  describe 'home' do
    it 'returns the home of the current user' do
      FS.home.should match(/\/#{Etc.getlogin}$/)
    end
    
    it 'returns the home of another user' do
      FS.home('root').should match(/\/root$/)
    end
  end

  describe 'currentdir' do
    it 'returns the current dir' do
      FS.currentdir.should eql(@test_dir)
    end
    
    it 'works after dir was changed' do
      here = FS.currentdir
      FS.makedir('foo')
      Dir.chdir('foo')
      FS.currentdir.should eql(File.join(here, 'foo'))
    end
  end
  
  describe 'changedir' do
    it 'change the current dir' do
      here = Dir.pwd
      FS.makedir('foo')
      FS.changedir('foo')
      Dir.pwd.should eql(File.join(here, 'foo'))
    end
  end
  
end
