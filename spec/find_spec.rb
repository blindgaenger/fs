require 'spec_helper'

describe FS::Find do
  before do
    FS.touch    'a.txt'
    FS.touch    'b.txt'
    FS.makedirs 'bar'
    FS.touch    'bar/c.txt'
    FS.makedirs 'bar/foo'
    FS.touch    'bar/foo/d.txt'
    FS.makedirs 'baz'
    FS.makedirs 'baz/lala'
    FS.touch    'e.txt'
  end

  describe '::find' do
    it 'returns the subdirs and files' do
      FS.find(@test_dir).should == %w(
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
      FS.find(@test_dir, :current => true).should == %w(
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
      FS.find(@test_dir, :absolute => true).should == [
        FS[@test_dir, 'a.txt'],
        FS[@test_dir, 'b.txt'],
        FS[@test_dir, 'bar'],
        FS[@test_dir, 'bar/c.txt'],
        FS[@test_dir, 'bar/foo'],
        FS[@test_dir, 'bar/foo/d.txt'],
        FS[@test_dir, 'baz'],
        FS[@test_dir, 'baz/lala'],
        FS[@test_dir, 'e.txt']
      ]
    end

    it 'yields the result' do
      result = []

      FS.find(@test_dir) do |path|
        result << path
      end

      result.should == %w(
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
      FS.find_dirs(@test_dir).should == %w(
        bar
        bar/foo
        baz
        baz/lala
      )
    end

    it 'yields dirs only' do
      result = []

      FS.find_dirs(@test_dir) do |path|
        result << path
      end

      result.should == %w(
        bar
        bar/foo
        baz
        baz/lala
      )
    end
  end

  describe '::find_files' do
    it 'returns files only' do
      FS.find_files(@test_dir).should == %w(
        a.txt
        b.txt
        bar/c.txt
        bar/foo/d.txt
        e.txt
      )
    end

    it 'yields files only' do
      result = []

      FS.find_files(@test_dir) do |path|
        result << path
      end

      result.should == %w(
        a.txt
        b.txt
        bar/c.txt
        bar/foo/d.txt
        e.txt
      )
    end
  end

end