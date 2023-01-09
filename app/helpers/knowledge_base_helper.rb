module KnowledgeBaseHelper

  def menu_tree(tree, path = '/kb')
    tree = tree.collect
    render 'menu_tree', locals: {
      tree: tree.collect do |title, item|
        {
          title:,
          path: item.is_a?(String) ? File.join(path, item) : File.join(path, item[:path]),
          children: item.is_a?(Hash) ? item.except(:path) : nil
        }
      end
    }
  end

end
