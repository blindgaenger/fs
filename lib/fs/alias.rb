module FS
  module Alias
    ALIASES = {
      :ls      => :list,
      :mkdir   => :makedir,
      :mkdir_p => :makedirs,
      :rmdir   => :removedir,
      :rm_r    => :removedirs,
      :cd      => :changedir,
      :mv      => :move,
      :cp      => :copy,
      :rm      => :remove,
      :cat     => :read,
      :ln      => :link,
    }
    
    def self.included(base)
      base.class_eval do
        ALIASES.each do |shortcut, original|
          alias_method shortcut, original          
        end
      end
    end
    
  end
end
