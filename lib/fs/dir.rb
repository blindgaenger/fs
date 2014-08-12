module FS
  module Dir
    extend self

    # Dir#home
    # the path is always expanded
    def home_dir(user=nil)
      File.expand_path(::Dir.home(user))
    end

    # Dir#pwd
    def current_dir
      ::Dir.pwd
    end

    # Dir#chdir
    def change_dir(dir)
      ::Dir.chdir(dir)
    end

  end
end