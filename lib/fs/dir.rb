module FS
  module Dir
    extend self

    # Dir#home
    # the path is always expanded
    def home_dir(user=nil)
      File.expand_path(::Dir.home(user))
    end

    # Dir#pwd
    def working_dir
      ::Dir.pwd
    end

    # Dir#chdir
    def change_dir(dir, &block)
      ::Dir.chdir(dir, &block)
    end

    # FileUtils#mkdir
    def make_dir(dir)
      FileUtils.mkdir(dir)
    end

    # FileUtils#mkdir_p
    def make_dir!(dir)
      FileUtils.mkdir_p(dir)
    end

    # FileUtils#rmdir
    def remove_dir(dir)
      raise Errno::ENOTEMPTY unless FS.empty?(dir)
      FileUtils.rmdir(dir)
    end

    # FileUtils#rm_r
    def remove_dir!(dir)
      FileUtils.rm_r(dir)
    end

  end
end
