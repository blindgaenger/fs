module FS
  module Alias
    ALIASES = {
      :ls      => :list,
      :mkdir   => :makedir,
      :mkdir_p => :makedirs,
      :rmdir   => :removedir,
      :rm_r    => :removedirs,
      :cd      => :changedir,
      :pwd     => :currentdir,
      :mv      => :move,
      :cp      => :copy,
      :rm      => :remove,
      :cat     => :read,
      :ln      => :link,
      :dir?    => :directory?,
      :expand  => :expand_path,
      :[]      => :join,
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
