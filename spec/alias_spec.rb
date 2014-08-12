require_relative 'spec_helper'

describe FS::Alias do

  FS::Alias::ALIASES.each do |shortcut, original|
    it "#{shortcut} exists for #{original}" do
      FS.respond_to?(shortcut).must_equal true
      FS.respond_to?(original).must_equal true
      s = FS.method(shortcut)
      o = FS.method(original)
      s.receiver.must_equal(o.receiver)
      s.parameters.must_equal(o.parameters)
    end
  end

end

