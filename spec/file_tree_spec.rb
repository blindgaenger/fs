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
end

