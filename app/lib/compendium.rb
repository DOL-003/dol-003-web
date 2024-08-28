class Compendium

  CONTENT_DIR = File.join(File.expand_path('.'), 'lib/compendium')

  def self.all_pages
    pages = []
    Dir.each_child(CONTENT_DIR) do |filename|
      full_path = File.join(CONTENT_DIR, filename)
      next unless File.file? full_path
      next unless File.extname(full_path) == '.md'
      page = FrontMatterParser::Parser.parse_file(full_path)
      pages << {
        slug: filename.gsub(/\.md$/, ''),
        title: page['title'],
        subtitle: page['subtitle'],
        tags: page['tags']
      }
    end
    pages
  end

end
