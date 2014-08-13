module FS
  module Alias
    ALIASES = {
      :ls      => :list,
      # :mkdir   => :make_dir,
      # :mkdir_p => :make_dirs,
      # :rmdir   => :remove_dir,
      # :rm_r    => :remove_dirs,
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
