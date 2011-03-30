class FS::FileTree 
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

  def to_ascii(seperator)
    indent(@paths,2,seperator)
  end

  def indent(hash,indentation_level, seperator)
    hash.each_pair.inject("") do |string,(parent,childs)|
      string << seperator.to_s * indentation_level + parent + (childs.empty? ? "\n" : "\/\n") 
      string << (indent(childs,indentation_level+2,seperator) unless childs.empty?).to_s
    end
  end
end

module FS::FileTreeWrapper
  def to_graph(seperator=" ")
    ::FS::FileTree.new(self).to_ascii(seperator)
  end
end
