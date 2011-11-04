require 'spec_helper'

describe FS::Alias do

  FS::Alias::ALIASES.each do |shortcut, original|
    it "#{shortcut} exists for #{original}" do
      FS.respond_to?(shortcut).should be_true
      FS.respond_to?(original).should be_true
      s = FS.method(shortcut)
      o = FS.method(original)
      s.receiver.should eql(o.receiver)
      s.parameters.should eql(o.parameters)
    end
  end

end

