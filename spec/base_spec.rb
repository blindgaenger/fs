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
  
  describe 'tree' do
    before(:each) do
      FS.touch('a.file')
      FS.makedir('baz')
      FS.touch('baz/b.file')
      FS.mkdir('baz/bar')
      FS.touch('baz/bar/c.file')
      FS.touch('baz/d.file')
      FS.makedir('foo')
      FS.touch('foo/e.file')
    end

    it 'returns the tree of the current dir' do
      tree = <<-TXT
.
|-- a.file
|-- baz
|   |-- b.file
|   |-- bar
|   |   `-- c.file
|   `-- d.file
`-- foo
    `-- e.file
TXT
      FS.tree.should eql(tree.strip)
    end

    it 'returns the tree of a dir' do
      tree = <<-TXT
baz
|-- b.file
|-- bar
|   `-- c.file
`-- d.file
TXT
      FS.tree('baz').should eql(tree.strip)
    end

  end
  
  describe 'exist?' do
    it 'returns if a path exist' do
      FS.makedir('foo')
      FS.touch('bar')
      FS.exist?('foo').should be_true
      FS.exist?('bar').should be_true
      FS.exist?('baz').should be_false
    end
  end

  describe 'directory?' do
    it 'checks for a directory' do
      FS.makedir('foo')
      FS.touch('bar')
      FS.directory?('foo').should be_true
      FS.directory?('bar').should be_false
      FS.directory?('baz').should be_false
    end
  end
  
  describe 'file?' do
    it 'checks for a file' do
      FS.makedir('foo')
      FS.touch('bar')
      FS.file?('foo').should be_false
      FS.file?('bar').should be_true
      FS.file?('baz').should be_false
    end
  end
  
  describe 'empty?' do
    it 'returns nil if the path does not exist' do
      FS.exist?('foobar').should be_false
      FS.empty?('foobar').should be_nil
    end
    
    it 'returns if a file is empty' do
      FS.touch('empty.file')
      FS.write('content.file', 'something')
      FS.empty?('empty.file').should be_true
      FS.empty?('content.file').should be_false
    end
    
    it 'returns if a dir is empty' do
      FS.mkdir('empty.dir')
      FS.mkdir('content.dir')
      FS.touch('content.dir/some.file')
      FS.empty?('empty.dir').should be_true
      FS.empty?('content.dir').should be_false
    end
  end
  
  describe 'join' do
    it 'joins pathes' do
      FS.join('foo', 'bar').should eql('foo/bar')
      FS.join('foo', '/bar').should eql('foo/bar')
      FS.join('foo/', 'bar').should eql('foo/bar')
    end 
  end
  
  describe 'expand_path' do
    it 'expands pathes' do
      here = File.expand_path('.')
      FS.expand_path('.').should eql(here)
      FS.expand_path('foo').should eql(File.join(here, 'foo'))
      FS.expand_path('foo/bar').should eql(File.join(here, 'foo', 'bar'))
    end
  end

  describe 'absolute?' do
    it 'checks for an absolute path' do
      FS.absolute?('/').should be_true
      FS.absolute?('/foo').should be_true
      FS.absolute?('.').should be_false
      FS.absolute?('foo').should be_false
    end
  end

  describe 'dirname' do
    it 'extracts the dir of a path' do
      FS.dirname('tmp/foo/bar.todo').should eql('tmp/foo')
      FS.dirname('tmp/foo').should eql('tmp')
      FS.dirname('tmp/foo/').should eql('tmp')
      FS.dirname('/tmp').should eql('/')
      FS.dirname('/').should eql('/')
      FS.dirname('.').should eql('.')
    end
  end

  describe 'basename' do
    it 'extracts the base of a path' do
      FS.basename('tmp/foo/bar.todo').should eql('bar.todo')
      FS.basename('tmp/foo').should eql('foo')
      FS.basename('tmp/foo/').should eql('foo')
      FS.basename('/tmp').should eql('tmp')
      FS.basename('/').should eql('/')
      FS.basename('.').should eql('.')
    end
  end
  
  describe 'filename' do
    it 'extracts the filename of a path' do
      FS.filename('tmp/foo/bar.todo').should eql('bar')
      FS.filename('tmp/foo').should eql('foo')
      FS.filename('tmp/foo/').should eql('foo')
      FS.filename('/tmp').should eql('tmp')
      FS.filename('/').should eql('') # this is not like FS.basename
      FS.filename('.').should eql('') # this is not like FS.basename
      FS.filename('foo.bar.txt').should eql('foo.bar')
    end
  end
  
  describe 'extname' do
    it 'extracts the extension of a path' do
      FS.extname('tmp/foo/bar.todo').should eql('.todo')
      FS.extname('tmp/foo').should eql('')
      FS.extname('tmp/foo/').should eql('')
      FS.extname('/tmp').should eql('')
      FS.extname('/').should eql('')
      FS.extname('.').should eql('')
      FS.extname('foo.bar.txt').should eql('.txt')
    end
  end
  
  describe 'splitname' do
    it 'splits the parts of a path' do
      FS.splitname('tmp/foo/bar.todo').should eql(["tmp/foo", "bar", ".todo"])
      FS.splitname('tmp/foo').should eql(['tmp', 'foo', ''])
      FS.splitname('tmp/foo/').should eql(['tmp', 'foo', ''])
      FS.splitname('/tmp').should eql(['/', 'tmp', ''])
      FS.splitname('/').should eql(['/', '', ''])
      FS.splitname('.').should eql(['.', '', ''])
    end
  end
  
  describe 'this_file' do
    it 'returns this file' do
      FS.this_file.should eql(__FILE__)
    end
  end

  describe 'this_dir' do
    it 'returns the dir of this file' do
      FS.this_dir.should eql(File.dirname(__FILE__))
    end
  end
  
  describe 'tempdir' do
    it 'returns the current temp dir' do
      FS.tempdir.should eql(Dir.tmpdir)
    end
  end
  
  describe 'maketempdir' do
    it 'creates a new dir in the default temp dir' do
      dir = FS.maketempdir
      File.exist?(dir).should be_true
      File.directory?(dir).should be_true
      Dir.entries(dir).should eql([".", ".."])
      Dir.entries(Dir.tmpdir).should include(File.basename(dir))
    end
    
    it 'creates a new temp dir with the given prefix' do
      dir = FS.maketempdir('my_dir')
      dir.should match(/\/my_dir/)
      File.exist?(dir).should be_true
      File.directory?(dir).should be_true
      Dir.entries(dir).should eql([".", ".."])
      Dir.entries(Dir.tmpdir).should include(File.basename(dir))
    end
    
    it 'creates a new temp dir inside of the given dir' do
      parent_dir = FS.maketempdir('parent_dir')
      dir = FS.maketempdir(nil, parent_dir)
      File.exist?(dir).should be_true
      File.directory?(dir).should be_true
      Dir.entries(dir).should eql([".", ".."])
      Dir.entries(parent_dir).should include(File.basename(dir))
    end
  end
  
  describe 'maketempfile' do
    it 'creates a new file in the default temp dir' do
      file = FS.maketempfile
      File.exist?(file).should be_true
      File.file?(file).should be_true
      File.size(file).should eql(0)
      Dir.entries(Dir.tmpdir).should include(File.basename(file))
    end

    it 'creates a new temp file with the given prefix' do
      file = FS.maketempfile('my_file')
      file.should match(/\/my_file/)
      File.exist?(file).should be_true
      File.file?(file).should be_true
      File.size(file).should eql(0)
      Dir.entries(Dir.tmpdir).should include(File.basename(file))
    end
    
    it 'creates a new temp file inside of the given dir' do
      parent_dir = FS.maketempdir('parent_dir')
      file = FS.maketempfile(nil, parent_dir)
      File.exist?(file).should be_true
      File.file?(file).should be_true
      File.size(file).should eql(0)
      Dir.entries(parent_dir).should include(File.basename(file))
    end
  end
  
end
