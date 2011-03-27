require 'fileutils'

module FS
  extend self

  # FileUtils.touch
  def touch(files)
    FileUtils.touch(files)
  end

  # FileUtils#mkdir
  def makedir(dirs)
    FileUtils.mkdir(dirs)
  end

  # FileUtils#mkdir_p
  def makedirs(dirs)
    FileUtils.mkdir_p(dirs)
  end
  
  # Dir#entries
  def list(dir, pattern='*')
    glob(dir, pattern)
  end
  
  # Find#find
  def find(dir, pattern='*')
    glob(dir, '**', pattern)
  end
  
  # FileUtils#mv
  def move(*froms, to)
    froms.each do |from|
      FileUtils.mv(from, to)
    end
  end

  # FileUtils#rm
  def remove(*pathes)
    FileUtils.rm(pathes, :verbose => true)
  end

  # File#open(file, 'w')
  def write(file, content=nil, &block)
    if block_given?
      File.open(file, 'w', &block)
    else
      File.open(file, 'w') {|f| f.write(content) }
    end
  end
  
  # File#open(file, 'r')
  def read(file, &block)
    if block_given?
      File.open(file, 'r', &block)
    else
      content = nil
      File.open(file, 'r') {|f| content = f.read }
      content
    end
  end

  
  def root
    '/'
  end
  
  def home(user=nil)
    Dir.home(user)
  end

  private
  
  def glob(dir, *patterns)
    Dir.glob(File.join(dir, patterns)).map do |path|
      path.gsub(/^\.?#{dir}\/?/, '')
    end
  end
  
end
