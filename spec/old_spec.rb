require_relative 'spec_helper'

describe FS::Old do
  before { reset_fs }

  describe '::touch' do
    it 'touches a single file' do
      file = 'foobar.txt'
      FS.touch(file)
      File.exist?(file).must_equal true
    end

    it 'accepts multiple files' do
      FS.touch('foo.txt', 'bar.txt')
      File.exist?('foo.txt').must_equal true
      File.exist?('bar.txt').must_equal true
    end

    it 'accepts a list of files' do
      files = ['foo.txt', 'bar.txt']
      FS.touch(files)
      files.each do |file|
        File.exist?(file).must_equal true
      end
    end
  end

  describe '::list' do
    it 'returns an empty list if there are no files' do
      FS.list.must_equal([])
    end

    it 'lists all files and dirs (without . and ..)' do
      FS.touch('file')
      FS.make_dir('dir')
      FS.list.must_equal(['dir', 'file'])
    end

    it 'lists files and dirs in the current dir' do
      FS.make_dir('foo')
      FS.make_dir('foo/dir')
      FS.touch('foo/file')
      Dir.chdir('foo')
      FS.list.must_equal(['dir', 'file'])
    end

    it 'globs files and dirs' do
      FS.touch('file.txt')
      FS.touch('file.rb')
      FS.make_dir('dir.txt')
      FS.make_dir('dir.rb')
      FS.list('.', '*.txt').must_equal(['dir.txt', 'file.txt'])
    end

    it 'globs files and dirs' do
      FS.touch('file.txt')
      FS.touch('file.rb')
      FS.make_dir('dir.txt')
      FS.make_dir('dir.rb')
      FS.list('.', '*.txt').must_equal(['dir.txt', 'file.txt'])
    end

    it 'lists files and dirs in a subdir' do
      FS.make_dir('foo')
      FS.make_dir('foo/dir')
      FS.touch('foo/file')
      FS.list('foo').must_equal(['dir', 'file'])
    end

    it 'globs files and dirs in a subdir' do
      FS.make_dir('foo')
      FS.touch('foo/file.txt')
      FS.touch('foo/file.rb')
      FS.make_dir('foo/dir.txt')
      FS.make_dir('foo/dir.rb')
      FS.list('foo', '*.txt').must_equal(['dir.txt', 'file.txt'])
    end

    it 'lists files in all subdirs' do
      FS.make_dir!('one/two/three')
      FS.touch('one/file.one')
      FS.touch('one/two/three/file.three')
      FS.list('.', '**/*').must_equal([
        'one',
        'one/file.one',
        'one/two',
        'one/two/three',
        'one/two/three/file.three'
      ])
    end

    it 'globs files in all subdirs' do
      FS.make_dir!('one/two/three')
      FS.touch('one/file.one')
      FS.touch('one/two/three/file.three')
      FS.list('.', '**/file.*').must_equal([
        'one/file.one',
        'one/two/three/file.three'
      ])
    end
  end

  describe '::list_dirs' do
    it 'lists dirs only' do
      FS.touch('bar.file')
      FS.make_dir('bar.dir')
      FS.touch('foo.file')
      FS.make_dir('foo.dir')
      FS.list_dirs.must_equal([
        'bar.dir',
        'foo.dir'
      ])
    end
  end

  describe '::list_files' do
    it 'lists files only' do
      FS.touch('bar.file')
      FS.make_dir('bar.dir')
      FS.touch('foo.file')
      FS.make_dir('foo.dir')
      FS.list_files.must_equal([
        'bar.file',
        'foo.file'
      ])
    end
  end

  describe '::move' do
    it 'renames a file' do
      FS.touch('foo.txt')
      FS.move('foo.txt', 'bar.txt')
      FS.list.must_equal(['bar.txt'])
    end

    it 'moves a file' do
      FS.touch('foo.txt')
      FS.make_dir('tmp')
      FS.move('foo.txt', 'tmp')
      FS.list.must_equal(['tmp'])
      FS.list('tmp').must_equal(['foo.txt'])
    end

    it 'moves files and dirs' do
      FS.touch('file')
      FS.make_dir('dir')
      FS.make_dir('tmp')
      FS.move('file', 'dir', 'tmp')
      FS.list.must_equal(['tmp'])
      FS.list('tmp').must_equal(['dir', 'file'])
    end
  end

  describe '::copy' do
    it 'copies a file' do
      FS.write('foo.txt', 'lala')
      FS.copy('foo.txt', 'bar.txt')
      File.exist?('foo.txt').must_equal true
      File.exist?('bar.txt').must_equal true
    end

    it 'copies the content' do
      FS.write('foo.txt', 'lala')
      FS.copy('foo.txt', 'bar.txt')
      FS.read('foo.txt').must_equal('lala')
      FS.read('bar.txt').must_equal('lala')
    end

    it 'copies a file to a dir' do
      FS.write('foo.txt', 'lala')
      FS.make_dir('dir')
      FS.copy('foo.txt', 'dir/bar.txt')
      File.exist?('foo.txt').must_equal true
      File.exist?('dir/bar.txt').must_equal true
    end
  end

  describe '::link' do
    it 'links to files' do
      FS.touch('foo.txt')
      FS.link('foo.txt', 'bar.txt')
      FS.write('foo.txt', 'lala')
      FS.read('bar.txt').must_equal('lala')
    end

    it 'links to dirs' do
      FS.make_dir('foo')
      FS.link('foo', 'bar')
      FS.touch('foo/file')
      FS.list('bar').must_equal(['file'])
    end
  end

  describe '::remove' do
    it 'removes files' do
      FS.touch('file')
      FS.remove('file')
      FS.list.must_equal([])
    end

    it 'removes multiple files' do
      FS.touch('file.a')
      FS.touch('file.b')
      FS.remove('file.a', 'file.b')
      FS.list.must_equal([])
    end

    it 'fails on dirs' do
      FS.make_dir('dir')
      ->{ FS.remove('dir') }.must_raise(Errno::EPERM)
    end

    # FIXME: fakefs
    # it 'fails if the dir is not empty' do
    #   FS.make_dir('/foo')
    #   FS.touch('/foo/bar')
    #   ->{ FS.remove('/foo') }.must_raise
    # end
  end

  describe '::write' do
    it 'writes content from a string' do
      FS.write('foo.txt', 'bar')
      File.open('foo.txt').read.must_equal('bar')
    end

    it 'writes content from a block' do
      FS.write('foo.txt') {|f| f.write 'bar' }
      File.open('foo.txt').read.must_equal('bar')
    end
  end

  describe '::read' do
    before do
      File.open('foo.txt', 'w') {|f| f.write 'bar' }
    end

    it 'reads the content to a string' do
      FS.read('foo.txt').must_equal('bar')
    end

    it 'yields the content to a block' do
      FS.read('foo.txt') {|content| content.must_equal('bar')}
    end
  end

  describe '::read_lines' do
    before do
      File.open('foo.txt', 'w') {|f| f.write "bar\nbaz\nqux" }
    end

    it 'reads all lines to an array' do
      FS.read_lines('foo.txt').must_equal(['bar', 'baz', 'qux'])
    end

    it 'yields all lines to a block' do
      lines = []
      FS.read_lines('foo.txt') {|line| lines << line}
      lines.must_equal(['bar', 'baz', 'qux'])
    end
  end

  describe '::grep' do
    before do
      File.open('foo.txt', 'w') {|f| f.write "this\nis\nthe\ntest" }
    end

    it 'greps matching lines to an array' do
      FS.grep('foo.txt', /is/).must_equal(['this', 'is'])
    end

    it 'yields matching lines to a block' do
      lines = []
      FS.grep('foo.txt', /is/) {|line| lines << line}
      lines.must_equal(['this', 'is'])
    end
  end

  describe '::exist?' do
    it 'returns if a path exist' do
      FS.make_dir('foo')
      FS.touch('bar')
      FS.exist?('foo').must_equal true
      FS.exist?('bar').must_equal true
      FS.exist?('baz').must_equal false
    end
  end

  describe '::directory?' do
    it 'checks for a directory' do
      FS.make_dir('foo')
      FS.touch('bar')
      FS.directory?('foo').must_equal true
      FS.directory?('bar').must_equal false
      FS.directory?('baz').must_equal false
    end
  end

  describe '::file?' do
    it 'checks for a file' do
      FS.make_dir('foo')
      FS.touch('bar')
      FS.file?('foo').must_equal false
      FS.file?('bar').must_equal true
      FS.file?('baz').must_equal false
    end
  end

  describe '::empty?' do
    it 'returns nil if the path does not exist' do
      FS.exist?('foobar').must_equal false
      ->{ FS.empty?('foobar') }.must_raise(Errno::ENOENT)
    end

    it 'returns if a file is empty' do
      FS.touch('empty.file')
      FS.write('content.file', 'something')
      FS.empty?('empty.file').must_equal true
      FS.empty?('content.file').must_equal false
    end

    it 'returns if a dir is empty' do
      FS.make_dir('empty.dir')
      FS.make_dir('content.dir')
      FS.touch('content.dir/some.file')
      FS.empty?('empty.dir').must_equal true
      FS.empty?('content.dir').must_equal false
    end
  end

  describe '::join' do
    it 'joins pathes' do
      FS.join('foo', 'bar').must_equal('foo/bar')
      FS.join('foo', '/bar').must_equal('foo/bar')
      FS.join('foo/', 'bar').must_equal('foo/bar')
    end
  end

  describe '::expand_path' do
    it 'expands pathes' do
      here = File.expand_path('.')
      FS.expand_path('.').must_equal(here)
      FS.expand_path('foo').must_equal(File.join(here, 'foo'))
      FS.expand_path('foo/bar').must_equal(File.join(here, 'foo', 'bar'))
    end

    it 'uses a base dir to expand the path' do
      here = File.expand_path('.')
      FS.expand_path('foo', nil).must_equal(File.join(here, 'foo'))
      FS.expand_path('foo', here).must_equal(File.join(here, 'foo'))
      FS.expand_path('foo', '/').must_equal('/foo')
      FS.expand_path('foo', '/bar').must_equal('/bar/foo')
      FS.expand_path('foo', '/bar/').must_equal('/bar/foo')
    end
  end

  describe '::chop_path' do
    it 'does nothing for relative paths' do
      FS.chop_path('.').must_equal('.')
      FS.chop_path('./foo').must_equal('foo')
      FS.chop_path('foo').must_equal('foo')
      FS.chop_path('foo/bar').must_equal('foo/bar')
    end

    it 'does not chop for non subdirs' do
      FS.chop_path('/').must_equal('/')
      FS.chop_path('..').must_equal(File.expand_path('..'))
      FS.chop_path('/foo', '/foo/bar').must_equal('/foo')
    end

    it 'chop absolute the path' do
      here = File.expand_path('.')
      FS.chop_path(here).must_equal('.')
      FS.chop_path(File.join(here, '.')).must_equal('.')
      FS.chop_path(File.join(here, 'foo')).must_equal('foo')
      FS.chop_path(File.join(here, 'foo/bar')).must_equal('foo/bar')
      FS.chop_path('/foo/bar').must_equal('/foo/bar')
    end

    it 'uses a base dir to chop the path' do
      FS.chop_path('.', '.').must_equal('.')
      FS.chop_path('/', '/').must_equal('.')
      FS.chop_path('/foo', '/foo').must_equal('.')
      FS.chop_path('/foo/bar', '/foo').must_equal('bar')
    end
  end

  describe '::absolute?' do
    it 'checks for an absolute path' do
      FS.absolute?('/').must_equal true
      FS.absolute?('/foo').must_equal true
      FS.absolute?('.').must_equal false
      FS.absolute?('foo').must_equal false
    end
  end

  describe '::dirname' do
    it 'extracts the dir of a path' do
      FS.dirname('tmp/foo/bar.todo').must_equal('tmp/foo')
      FS.dirname('tmp/foo').must_equal('tmp')
      FS.dirname('tmp/foo/').must_equal('tmp')
      FS.dirname('/tmp').must_equal('/')
      FS.dirname('/').must_equal('/')
      FS.dirname('.').must_equal('.')
    end
  end

  describe '::basename' do
    it 'extracts the base of a path' do
      FS.basename('tmp/foo/bar.todo').must_equal('bar.todo')
      FS.basename('tmp/foo').must_equal('foo')
      FS.basename('tmp/foo/').must_equal('foo')
      FS.basename('/tmp').must_equal('tmp')
      FS.basename('/').must_equal('/')
      FS.basename('.').must_equal('.')
    end
  end

  describe '::filename' do
    it 'extracts the filename of a path' do
      FS.filename('tmp/foo/bar.todo').must_equal('bar')
      FS.filename('tmp/foo').must_equal('foo')
      FS.filename('tmp/foo/').must_equal('foo')
      FS.filename('/tmp').must_equal('tmp')
      FS.filename('/').must_equal('') # this is not like FS.basename
      FS.filename('.').must_equal('') # this is not like FS.basename
      FS.filename('foo.bar.txt').must_equal('foo.bar')
    end
  end

  describe '::extname' do
    it 'extracts the extension of a path' do
      FS.extname('tmp/foo/bar.todo').must_equal('.todo')
      FS.extname('tmp/foo').must_equal('')
      FS.extname('tmp/foo/').must_equal('')
      FS.extname('/tmp').must_equal('')
      FS.extname('/').must_equal('')
      FS.extname('.').must_equal('')
      FS.extname('foo.bar.txt').must_equal('.txt')
    end
  end

  describe '::splitname' do
    it 'splits the parts of a path' do
      FS.splitname('tmp/foo/bar.todo').must_equal(["tmp/foo", "bar", ".todo"])
      FS.splitname('tmp/foo').must_equal(['tmp', 'foo', ''])
      FS.splitname('tmp/foo/').must_equal(['tmp', 'foo', ''])
      FS.splitname('/tmp').must_equal(['/', 'tmp', ''])
      FS.splitname('/').must_equal(['/', '', ''])
      FS.splitname('.').must_equal(['.', '', ''])
    end
  end

  describe '::this_file' do
    it 'returns this file' do
      FS.this_file.must_equal(__FILE__)
    end
  end

  describe '::this_dir' do
    it 'returns the dir of this file' do
      FS.this_dir.must_equal(File.dirname(__FILE__))
    end
  end

  describe '::tempdir' do
    it 'returns the current temp dir' do
      FS.tempdir.must_equal(Dir.tmpdir)
    end
  end

  describe '::maketempdir' do
    it 'creates a new dir in the default temp dir' do
      dir = FS.maketempdir
      File.exist?(dir).must_equal true
      File.directory?(dir).must_equal true
      Dir.entries(dir).must_equal(['.', '..'])
      Dir.entries(Dir.tmpdir).must_include(File.basename(dir))
    end

    it 'creates a new temp dir with the given prefix' do
      dir = FS.maketempdir('my_dir')
      dir.must_match(/\/my_dir/)
      File.exist?(dir).must_equal true
      File.directory?(dir).must_equal true
      Dir.entries(dir).must_equal(['.', '..'])
      Dir.entries(Dir.tmpdir).must_include(File.basename(dir))
    end

    it 'creates a new temp dir inside of the given dir' do
      parent_dir = FS.maketempdir('parent_dir')
      dir = FS.maketempdir(nil, parent_dir)
      File.exist?(dir).must_equal true
      File.directory?(dir).must_equal true
      Dir.entries(dir).must_equal(['.', '..'])
      Dir.entries(parent_dir).must_include(File.basename(dir))
    end
  end

  describe '::maketempfile' do
    it 'creates a new file in the default temp dir' do
      file = FS.maketempfile
      FS.exist?(file).must_equal true
      FS.file?(file).must_equal true
      FS.empty?(file).must_equal true
      FS.list(Dir.tmpdir).must_include(File.basename(file))
    end

    it 'creates a new temp file with the given prefix' do
      file = FS.maketempfile('my_file')
      file.must_match(/\/my_file/)
      FS.exist?(file).must_equal true
      FS.file?(file).must_equal true
      FS.empty?(file).must_equal true
      FS.list(Dir.tmpdir).must_include(File.basename(file))
    end

    it 'creates a new temp file inside of the given dir' do
      parent_dir = FS.maketempdir('parent_dir')
      file = FS.maketempfile(nil, parent_dir)
      FS.exist?(file).must_equal true
      FS.file?(file).must_equal true
      FS.empty?(file).must_equal true
      FS.list(parent_dir).must_include(File.basename(file))
    end
  end

end
