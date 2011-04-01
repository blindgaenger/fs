require 'spec_helper'

describe FS::FileTree do
  describe "basic graph printing" do
    #it "lists tree consisting only out of leafs" do
    #  FS::FileTree.new(["file", "file"]).to_ascii.should ==  "`--file\n"
    #end

    it "can handle complexer file trees" do
      FS::FileTree.new(["path/to/file","path/to/other/file", "some/other/path"]).to_ascii.should == <<EOF
|--path/
|  `--to/
|     |--file
|     `--other/
|        `--file
`--some/
   `--other/
      `--path
EOF

    end

    describe "to_tree wrapper for the FS Module" do
      it "provides a to_tree method for arrays of pathes" do
        FS.makedirs('one/two/three')
        FS.touch('one/file.one')
        FS.touch('one/two/three/file.three')
        FS.to_tree(FS.find).should ==
          <<TREE
`--one/
   |--file.one
   `--two/
      `--three/
         `--file.three
TREE

      end
      it "works with output of find calle with a search pattern" do
        FS.makedirs('foo/bar')
        FS.makedir('foo/baz')
        FS.touch('foo/bar/ruby1.rb')
        FS.touch('foo/ruby2.rb')
        FS.to_tree(FS.find('.', "*.rb")).should == <<EOF
`--foo/
   |--bar/
   |  `--ruby1.rb
   `--ruby2.rb
EOF
      end


      it "provides a to_grpah method for a string" do
        FS.to_tree("path/to/file").should  ==
          <<TREE
`--path/
   `--to/
      `--file
TREE
      end
    end
  end
end
