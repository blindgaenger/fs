module FS
  module Old

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
        raise Errno::ENOTEMPTY unless empty?(dir)
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

    def list_dirs(dir='.', pattern='*')
      glob(dir, pattern) {|path| FS.directory?(path) }
    end

    def list_files(dir='.', pattern='*')
      glob(dir, pattern) {|path| FS.file?(path) }
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

    # File#open(file, 'r').read
    def read(file, &block)
      if block_given?
        File.open(file, 'r') {|f| block[f.read] }
      else
        content = nil
        File.open(file, 'r') {|f| content = f.read }
        content
      end
    end

    # File#open(file, 'r').each
    def read_lines(file, &block)
      if block_given?
        File.open(file, 'r').each {|line| line.chomp!; block[line] }
      else
        lines = []
        File.open(file, 'r').each {|line| line.chomp!; lines << line }
        lines
      end
    end

    # File#open(file, 'r') =~ /REGEX/
    def grep(file, regexp, &block)
      if block_given?
        File.open(file, 'r').each {|line| line.chomp!; block[line] if line =~ regexp }
      else
        lines = []
        File.open(file, 'r').each {|line| line.chomp!; lines << line if line =~ regexp }
        lines
      end
    end

    # tmpdir / ::Dir.tmpdir
    def tempdir
      ::Dir.tmpdir
    end

    # TODO: use separate options for prefix, suffix and target_dir
    # tmpdir / ::Dir.mktmpdir
    def maketempdir(prefix_suffix=nil, parent_dir=nil)
      ::Dir.mktmpdir(prefix_suffix, parent_dir)
    end

    # uses the methods of the tmpdir library to touch a new file in tempdir
    def maketempfile(prefix_suffix=nil, parent_dir=nil)
      ::Dir::Tmpname.create(prefix_suffix || "f", parent_dir || ::Dir.tmpdir) {|n| FileUtils.touch(n)}
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

    # uses File.size and ::Dir.entries
    # for files it returns `nil` if file does not exist, `true` if it's empty
    def empty?(path)
      raise Errno::ENOENT unless File.exist?(path)
      if File.directory?(path)
        files = ::Dir.entries(path)
        files.size == 2 && files.sort == ['.', '..']
      else
        File.size(path) == 0
      end
    end

    # File.join
    def join(*args)
      File.join(*args)
    end

    # File.expand_path
    def expand_path(path, base=nil)
      File.expand_path(path, base)
    end

    # chop base from the path
    # if it's not a subdir the absolute path will be returned
    def chop_path(path, base='.')
      full_base = File.expand_path(base)
      full_path = File.expand_path(path)
      if full_path == full_base
        '.'
      elsif full_path.start_with?(full_base)
        full_path[full_base.size+1..-1]
      else
        full_path
      end
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
      return base if ext.empty?
      base[0...-ext.size]
    end

    # "tmp/foo/bar.todo" => ["tmp/foo", "bar", ".todo"]
    def splitname(path)
      [dirname(path), filename(path), extname(path)]
    end

    # __FILE__ of the caller
    # the path is always expanded
    def this_file
      File.expand_path(caller_file(caller))
    end

    # File.dirname(__FILE__) of the caller
    # the path is always expanded
    def this_dir
      File.expand_path(File.dirname(caller_file(caller)))
    end

    private

    def glob(dir, *patterns, &block)
      fulldir = File.expand_path(dir)
      regexp = /^#{Regexp.escape(fulldir)}\/?/
      ::Dir.
        glob(File.join(fulldir, patterns)).
        select {|path| block.nil? || block[path] }.
        map {|path| path.gsub(regexp, '') }.
        sort
    end

    def caller_file(trace)
      if arr = parse_caller(trace.first)
        arr.first
      end
    end

    # http://grosser.it/2009/07/01/getting-the-caller-method-in-ruby/
    # Stolen from ActionMailer, where it wasn't reusable
    def parse_caller(at)
      if /^(.+?):(\d+)(?::in `(.*)')?/ =~ at
        file   = Regexp.last_match[1]
        line   = Regexp.last_match[2].to_i
        method = Regexp.last_match[3]
        [file, line, method]
      end
    end

  end
end