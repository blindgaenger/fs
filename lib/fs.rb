require 'fileutils'

module FS
  extend self

  # FileUtils.touch
  def touch(files)
    FileUtils.touch(files)
  end

  # Dir#entries
  def list(dir)
    Dir.entries(dir)[2..-1]
  end

  # FileUtils#mkdir
  def makedir(dirs)
    FileUtils.mkdir(dirs)
  end

  # FileUtils#mkdir_p
  def makedirs(dirs)
    FileUtils.mkdir_p(dirs)
  end
end
