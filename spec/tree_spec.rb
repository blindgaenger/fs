require_relative 'spec_helper'

describe FS::Tree do
  before { reset_fs }

  describe '::tree' do
    before(:each) do
      FS.touch('a.file')
      FS.make_dir('baz')
      FS.touch('baz/b.file')
      FS.make_dir!('baz/bar')
      FS.touch('baz/bar/c.file')
      FS.touch('baz/d.file')
      FS.make_dir('foo')
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
      FS.tree.must_equal(tree.strip)
    end

    it 'returns the tree of a dir' do
      tree = <<-TXT
baz
|-- b.file
|-- bar
|   `-- c.file
`-- d.file
TXT
      FS.tree('baz').must_equal(tree.strip)
    end

  end

end
