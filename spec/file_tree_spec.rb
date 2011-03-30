require 'spec_helper'

describe FS::FileTree do
  describe "basic graph printing" do
    it "lists tree consisting only out of leafs" do
      FS::FileTree.new(["file", "file"]).to_ascii("*").should ==  "**file\n"
    end

    it "can handle complexer file trees" do
      FS::FileTree.new(["path/to/file","path/to/other/file", "some/other/path"]).to_ascii("*").should == <<EOF
**path/
****to/
******file
******other/
********file
**some/
****other/
******path
EOF
    end
  end


  describe "to_graph wrapper for the FS Module" do
    it "provides a to_graph method" do
      FS.makedirs('one/two/three')
      FS.touch('one/file.one')
      FS.touch('one/two/three/file.three')
      FS.find.to_graph("*").should ==
        <<TREE
**one/
****file.one
****two/
******three/
********file.three
TREE
    end
  end
end

