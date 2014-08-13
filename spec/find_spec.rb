require_relative 'spec_helper'

describe FS::Find do
  before do
    reset_fs
    FS.touch     'a.txt'
    FS.touch     'b.txt'
    FS.make_dir! 'bar'
    FS.touch     'bar/c.txt'
    FS.make_dir! 'bar/foo'
    FS.touch     'bar/foo/d.txt'
    FS.make_dir! 'baz'
    FS.make_dir! 'baz/lala'
    FS.touch     'e.txt'
  end

  describe '::find' do
    it 'returns the subdirs and files' do
      FS.find(TEST_DIR).must_equal %w(
        a.txt
        b.txt
        bar
        bar/c.txt
        bar/foo
        bar/foo/d.txt
        baz
        baz/lala
        e.txt
      )
    end

    it 'returns current dir, subdirs and files' do
      FS.find(TEST_DIR, :current => true).must_equal %w(
        .
        a.txt
        b.txt
        bar
        bar/c.txt
        bar/foo
        bar/foo/d.txt
        baz
        baz/lala
        e.txt
      )
    end

    it 'returns the full path' do
      FS.find(TEST_DIR, :absolute => true).must_equal [
        FS[TEST_DIR, 'a.txt'],
        FS[TEST_DIR, 'b.txt'],
        FS[TEST_DIR, 'bar'],
        FS[TEST_DIR, 'bar/c.txt'],
        FS[TEST_DIR, 'bar/foo'],
        FS[TEST_DIR, 'bar/foo/d.txt'],
        FS[TEST_DIR, 'baz'],
        FS[TEST_DIR, 'baz/lala'],
        FS[TEST_DIR, 'e.txt']
      ]
    end

    it 'yields the result' do
      result = []

      FS.find(TEST_DIR) do |path|
        result << path
      end

      result.must_equal %w(
        a.txt
        b.txt
        bar
        bar/c.txt
        bar/foo
        bar/foo/d.txt
        baz
        baz/lala
        e.txt
      )
    end
  end

  describe '::find_dirs' do
    it 'returns dirs only' do
      FS.find_dirs(TEST_DIR).must_equal %w(
        bar
        bar/foo
        baz
        baz/lala
      )
    end

    it 'yields dirs only' do
      result = []

      FS.find_dirs(TEST_DIR) do |path|
        result << path
      end

      result.must_equal %w(
        bar
        bar/foo
        baz
        baz/lala
      )
    end
  end

  describe '::find_files' do
    it 'returns files only' do
      FS.find_files(TEST_DIR).must_equal %w(
        a.txt
        b.txt
        bar/c.txt
        bar/foo/d.txt
        e.txt
      )
    end

    it 'yields files only' do
      result = []

      FS.find_files(TEST_DIR) do |path|
        result << path
      end

      result.must_equal %w(
        a.txt
        b.txt
        bar/c.txt
        bar/foo/d.txt
        e.txt
      )
    end
  end

end