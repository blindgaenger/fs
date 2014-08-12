module FS
  module Tree

    # same as the `tree` shell command
    def tree(dir='.')
      output = []
      visit_tree(output, '.', '', '', '', dir)
      output.join("\n")
    end

    private

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
