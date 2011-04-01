module FS
  class FileTree 
    def initialize(array_of_pathes)
      @paths = {}
      extract_paths(array_of_pathes)
    end

    def extract_paths(array)
      array.each do |item| 
        item.split(/\//).inject(@paths) do |paths,part|
          paths[part] ||= {}
        end
      end
    end

    def to_ascii
      indent(@paths, "")
    end

    def indent(hash,indentation_string)
      hash.each_pair.with_index.inject("") do |string,((parent,childs),ind)|
        indentation_string.gsub!(/[`-]/," ")
      indentation_string << (ind + 1 < hash.length  ? "|" : "`" ) << "-" * 2
      string << indentation_string << parent + (childs.empty? ? "\n" : "\/\n") 
      string << (indent(childs,indentation_string.dup) unless childs.empty?).to_s
      indentation_string = indentation_string[0..-4] 
      string
      end
    end
  end

  module FileTreeWrapper
    def to_tree(paths)
      paths = [paths] if paths.is_a?(String)
      ::FS::FileTree.new(paths).to_ascii
    end
  end
end
