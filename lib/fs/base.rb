module FS
  module Base
    
    # FileUtils.touch
    def touch(*files)
      FileUtils.touch(files)
    end

    # FileUtils#mkdir
    def makedir(*dirs)
      FileUtils.mkdir(dirs)
    end

    # FileUtils#mkdir_p
    def makedirs(*dirs)
      FileUtils.mkdir_p(dirs)
    end

    # FileUtils#rmdir
    def removedir(*dirs)
      dirs.each do |dir|
        raise Errno::ENOTEMPTY unless list(dir).empty?
      end
      FileUtils.rmdir(dirs)
    end

    # FileUtils#rm_r
    def removedirs(*dirs)
      FileUtils.rm_r(dirs)
    end

    # Dir#glob
    def list(dir='.', pattern='*')
      glob(dir, pattern)
    end

    # Dir#glob
    # TODO: use Find#find
    def find(dir='.', pattern='*')
      glob(dir, '**', pattern)
    end

    # TODO: find time to make this cool, not work only
    # FileUtils#mv
    def move(*froms, to)
      froms.each do |from|
        FileUtils.mv(from, to)        
      end
    end

    # TODO: find time to make this cool, not work only
    # FileUtils#cp
    def copy(*froms, to)
      froms.each do |from|
        FileUtils.cp(from, to)
      end
    end
    
    # Creates hard links for files and symbolic links for dirs
    #
    # FileUtils#ln or FileUtils#ln_s
    def link(from, to)
      if File.directory?(from)
        FileUtils.ln_s(from, to)
      else
        FileUtils.ln(from, to)
      end
    end
    
    # FileUtils#rm
    def remove(*pathes)
      FileUtils.rm(pathes)
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

    # Dir#home
    def home(user=nil)
      Dir.home(user)
    end

    # always returns '/'
    def root
      '/'
    end

    # Dir#chdir
    def changedir(dir)
      Dir.chdir(dir)
    end
    
    # Dir#pwd
    def currentdir
      Dir.pwd
    end

    # same as the `tree` shell command
    def tree(dir='.')
      output = []
      visit_tree(output, '.', '', '', '', dir)
      output.join("\n")
    end

    # File.exist?
    def exist?(path)
      File.exist?(path)
    end

    # File.directory?
    def directory?(path)
      File.directory?(path)
    end

    # File.file?
    def file?(path)
      File.file?(path)
    end

    # File.join
    def join(*args)
      File.join(*args)
    end

    # File.expand_path
    def expand_path(path)
      File.expand_path(path)
    end

    # checks for a slash at the beginning
    def absolute?(path)
      %r{\A/} =~ path ? true : false
    end

    # File.dirname
    # "tmp/foo/bar.todo" => "tmp/foo"
    def dirname(path)
      File.dirname(path)
    end

    # File.basename
    # "tmp/foo/bar.todo" => "bar.todo"
    def basename(path)
      File.basename(path)
    end

    # File.extname
    # "tmp/foo/bar.todo" => ".todo"
    def extname(path)
      File.extname(path)
    end

    # "tmp/foo/bar.todo" => "bar"
    def filename(path)
      return '' if path == '/' || path == '.'
      base = File.basename(path)
      ext = File.extname(path)
      ext.empty? ? base :base[0...-ext.size]  
    end

    # "tmp/foo/bar.todo" => ["tmp/foo", "bar", ".todo"]
    def splitname(path)
      [dirname(path), filename(path), extname(path)]
    end

    private
    
    def assert_dir(path)
      raise "not a directory: #{path}" unless File.directory?(path)
    end

    def glob(dir, *patterns)
      fulldir = File.expand_path(dir)
      Dir.glob(File.join(fulldir, patterns)).map do |path|
        path.gsub(/^#{fulldir}\/?/, '')
      end
    end
    
    def visit_tree(output, parent_path, indent, arm, tie, node)
      output << "#{indent}#{arm}#{tie}#{node}"
      
      node_path = File.expand_path(node, parent_path)
      return unless File.directory?(node_path) && File.readable?(node_path)
      
      subnodes = FS.list(node_path)
      return if subnodes.empty?
      
      arms = Array.new(subnodes.length - 1, '|') << '`'
      arm_to_indent = {
        ''  => '',
        '|' => '|   ',
        '`' => '    '
      }
      subnodes.each_with_index do |subnode, index|
        visit_tree(output, node_path, indent + arm_to_indent[arm], arms[index], '-- ', subnode)
      end
    end
    
  end
end