module FS
  module Find

    # Find::find
    def find(dir, options={}, &block)
      defaults = {
        :current => false,
        :absolute => false,
        :condition => nil
      }
      options = defaults.merge(options)

      result = []

      full_dir = File.expand_path(dir)
      ::Find.find(dir) do |full_path|
        next if !options[:current] && full_path == full_dir
        path = options[:absolute] ? full_path : FS.chop(full_path, full_dir)
        next if options[:condition] && !options[:condition][path]

        if block
          block[path]
        else
          result << path
        end
      end

      block ? nil : result
    end

    def find_dirs(dir, options={}, &block)
      condition = ->(path){FileTest.directory?(path)}
      find(dir, options.merge(:condition => condition), &block)
    end

    def find_files(dir, options={}, &block)
      condition = ->(path){!FileTest.directory?(path)}
      find(dir, options.merge(:condition => condition), &block)
    end

  end
end