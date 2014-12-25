require_relative 'spec_helper'

describe FS::Dir do
  before { reset_fs }

  describe '.home_dir' do
    it 'returns the home of the current user' do
      FS::Dir.home_dir.must_match(/\/#{Etc.getlogin}$/)
    end

    it 'returns the home of another user' do
      FS::Dir.home_dir('root').must_match(/\/root$/)
    end
  end

  describe '.working_dir' do
    it 'returns the current dir' do
      FS::Dir.working_dir.must_equal(TEST_DIR)
    end

    it 'works after dir was changed' do
      here = FS::Dir.working_dir
      FileUtils.mkdir('foo')
      Dir.chdir('foo')

      FS::Dir.working_dir.must_equal(File.join(here, 'foo'))
    end
  end

  describe '.change_dir' do
    it 'changes the current dir' do
      here = Dir.pwd
      FileUtils.mkdir('foo')

      FS::Dir.change_dir('foo')

      Dir.pwd.must_equal(File.join(here, 'foo'))
    end

    it 'changes the dir only within the given block' do
      here = Dir.pwd
      FileUtils.mkdir('foo')

      FS::Dir.change_dir 'foo' do |dir|
        dir.must_equal 'foo'
        Dir.pwd.must_equal File.join(here, 'foo')
      end

      Dir.pwd.must_equal(here)
    end
  end

  describe '.make_dir' do
    context 'dir does not exist' do
      it 'creates a dir'
    end

    context 'some parent dirs do already exist' do
      it 'creates a dir'
    end

    context 'dir does already exist' do
      it 'raises an error'
    end

    context 'dir contains a file in the path' do
      it 'raises an error'
    end
  end

  describe '.make_dir' do
    it 'creates a dir' do
      FS::Dir.make_dir('foo')
      File.directory?('foo').must_equal true
    end

    it 'fails if a parent dir is missing' do
      ->{ FS::Dir.make_dir('foo/bar') }.must_raise(Errno::ENOENT)
    end
  end

  describe '.make_dir!' do
    it 'creates all missing parent dirs' do
      FS::Dir.make_dir!('foo/bar/baz')

      File.directory?('foo').must_equal true
      File.directory?('foo/bar').must_equal true
      File.directory?('foo/bar/baz').must_equal true
    end
  end

  describe '.remove_dir' do
    it 'removes a dir' do
      FileUtils.mkdir('foo')

      FS::Dir.remove_dir('foo')

      File.exist?('foo').must_equal false
    end

    it 'fails if dir not empty' do
      FileUtils.mkdir_p('foo/dir')
      FileUtils.touch('foo/file')

      ->{
        FS::Dir.remove_dir('foo')
      }.must_raise(Errno::ENOTEMPTY)
    end
  end

  describe '.remove_dir!' do
    it 'removes a dir' do
      FileUtils.mkdir('foo')

      FS::Dir.remove_dir('foo')

      File.exist?('foo').must_equal false
    end

    it 'removes a dir even if something is inside' do
      FileUtils.mkdir_p('foo/dir')
      FileUtils.touch('foo/file')

      FS::Dir.remove_dir!('foo')

      File.exist?('foo').must_equal false
    end
  end

end
