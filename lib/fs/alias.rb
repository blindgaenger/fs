module FS
  module Alias
    ALIASES = {
      :ls      => :list,
      :mkdir   => :makedir,
      :mkdir_p => :makedirs,
      :rmdir   => :removedir,
      :rm_r    => :removedirs,
      :cd      => :change_dir,
      :pwd     => :current_dir,
      :mv      => :move,
      :cp      => :copy,
      :rm      => :remove,
      :cat     => :read,
      :ln      => :link,
      :dir?    => :directory?,
      :expand  => :expand_path,
      :chop    => :chop_path,
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
