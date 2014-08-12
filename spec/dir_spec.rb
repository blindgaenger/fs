require_relative 'spec_helper'

describe FS::Dir do
  before { reset_fs }

  describe 'home_dir' do
    it 'returns the home of the current user' do
      FS::Dir.home_dir.must_match(/\/#{Etc.getlogin}$/)
    end

    it 'returns the home of another user' do
      FS::Dir.home_dir('root').must_match(/\/root$/)
    end
  end

  describe 'current_dir' do
    it 'returns the current dir' do
      FS::Dir.current_dir.must_equal(TEST_DIR)
    end

    it 'works after dir was changed' do
      here = FS::Dir.current_dir
      FS.makedir('foo')
      Dir.chdir('foo')
      FS::Dir.current_dir.must_equal(File.join(here, 'foo'))
    end
  end

  describe 'change_dir' do
    it 'changes the current dir' do
      here = Dir.pwd
      FS.makedir('foo')
      FS::Dir.change_dir('foo')
      Dir.pwd.must_equal(File.join(here, 'foo'))
    end
  end
end
