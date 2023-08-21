class CompendiumController < ApplicationController

  CONTENT_DIR = File.join(File.expand_path('.'), 'app/views/compendium/content')
  @@pages = {}
  @@nav = {}

  def show
    return not_found unless flag_enabled? :compendium

    page = page_data(params[:path] || 'index')
    return not_found if page.blank?

    @title = page[:title]
    @subtitle = page[:subtitle]
    @content = page[:content]
    @nav = nav
    @current_path = "/compendium/#{params[:path] || 'index'}"
  end

  private

  def page_data(path)
    return @@pages[path] if @@pages[path].present? && !Rails.env.development?

    filepath = "#{File.expand_path(File.join(CONTENT_DIR, path))}.md"
    return nil unless filepath.starts_with? CONTENT_DIR

    index_filepath = nil
    if !File.file? filepath
      index_filepath = File.expand_path(File.join(CONTENT_DIR, path, 'index.md'))
      return nil unless index_filepath.starts_with? CONTENT_DIR
      return nil unless File.file? index_filepath
    end

    page = FrontMatterParser::Parser.parse_file(index_filepath || filepath)

    @@pages[path] = {
      title: page['title'],
      subtitle: page['subtitle'],
      content: page['auto'].present? ? auto_page(path, filepath) : Kramdown::Document.new(page.content).to_html.html_safe
    }
  end

  def auto_page(path, filepath)
    subpages = []
    dirpath = filepath.gsub(/\.md$/, '')
    Dir.each_child(dirpath) do |filename|
      next if filename == 'index.md'
      page = FrontMatterParser::Parser.parse_file(File.expand_path(File.join(dirpath, filename)))
      next if page.blank?
      subpages << {
        path: File.join(path, filename.gsub(/\.md$/, '')),
        title: page['title'],
        subtitle: page['subtitle']
      }
    end
    render_to_string 'auto_page', layout: false, locals: { subpages: subpages.sort_by { |subpage| subpage[:title] } }
  end

  def nav
    return @@nav if @@nav.present? && !Rails.env.development?

    nav_data = YAML.load(File.read('./app/lib/compendium-nav.yml')).deep_symbolize_keys.freeze

    @@nav = nav_data[:pages].reduce([]) do |nav_items, path|
      nav_items << generate_nav_item(path)
    end
  end

  def generate_nav_item(path)
    return 'separator' if path == '---'

    filepath = File.expand_path(File.join(CONTENT_DIR, path)).gsub(/\.md$/, '')
    dir = File.directory?(filepath)
    page = FrontMatterParser::Parser.parse_file(dir ? File.join(filepath, 'index.md') : "#{filepath}.md")

    nav_item = {
      dir:,
      path:,
      label: page['label'] || page['title'] || '(blank)',
    }

    if dir
      nav_item[:children] = Dir.each_child(filepath).map do |filename|
        next if filename == 'index.md'
        generate_nav_item(File.join(path, filename))
      end.compact.sort_by { |item| "#{item[:dir]} #{item[:label]}" }
    end

    nav_item

  end

end
