module KnowledgeBaseHelper

  def menu_tree(tree, path = '/kb')
    tree = tree.collect
    render 'menu_tree', locals: {
      tree: tree.collect do |title, item|
        if item == nil
          'separator'
        else
          {
            title:,
            path: item.is_a?(String) ? File.join(path, item) : File.join(path, item[:path]),
            children: item.is_a?(Hash) ? item.except(:path) : nil
          }
        end
      end
    }
  end

  def path_matches?(path, current_path, complete_match: false)
    if complete_match
      Pathname.new(current_path).cleanpath.to_s == Pathname.new(path).cleanpath.to_s
    else
      Pathname.new(current_path).cleanpath.to_s.starts_with? Pathname.new(path).cleanpath.to_s
    end
  end

end
