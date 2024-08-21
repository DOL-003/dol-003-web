class CompendiumController < ApplicationController

  CONTENT_DIR = File.join(File.expand_path('.'), 'lib/compendium')
  @@pages = {}
  @@nav = {}

  def show
    return not_found unless flag_enabled? :compendium

    page = page_data(params[:path] || 'index')
    return not_found if page.blank?

    @title = page[:title]
    @subtitle = page[:subtitle]
    @content = page[:content]
    @stub = page[:stub]
    @path = page[:path]
    @nav = nav
    @current_path = "/compendium/#{params[:path] || 'index'}"
  end

  private

  def page_data(path)
    return @@pages[path] if @@pages[path].present? && !Rails.env.development?

    filepath = "#{File.expand_path(File.join(CONTENT_DIR, path))}.md"
    return nil unless filepath.starts_with? CONTENT_DIR

    index_filepath = nil
    unless File.file? filepath
      index_filepath = File.expand_path(File.join(CONTENT_DIR, path, 'index.md'))
      return nil unless index_filepath.starts_with? CONTENT_DIR
      return nil unless File.file? index_filepath
    end

    page = FrontMatterParser::Parser.parse_file(index_filepath || filepath)

    @@pages[path] = {
      title: RubyPants.new(page['title']).to_html.html_safe,
      subtitle: page['subtitle'].present? ? RubyPants.new(page['subtitle']).to_html.html_safe : nil,
      content: page_content(path:, filepath:, page:),
      stub: page['stub'].present?,
      path: index_filepath.present? ? "#{path}/index.md" : "#{path}.md"
    }
  end

  def auto_page(path:, filepath:)
    subpages = []
    dirpath = filepath.gsub(/\.md$/, '')
    Dir.each_child(dirpath) do |filename|
      next if filename == 'index.md'
      page = FrontMatterParser::Parser.parse_file(File.expand_path(File.join(dirpath, filename)))
      next if page.blank?
      subpages << {
        path: File.join(path, filename.gsub(/\.md$/, '')),
        title: page['label'] || page['title'],
        subtitle: page['subtitle']
      }
    end
    render_to_string 'auto_page', layout: false, locals: { subpages: subpages.sort_by { |subpage| subpage[:title] } }
  end

  def list_page(match)
    pages = all_pages.filter { |page| page[:path].match? match }.sort_by { |page| page[:title] }
    render_to_string 'auto_page', layout: false, locals: { subpages: pages }
  end

  def all_pages(dir = '')
    pages = []
    Dir.each_child(File.join(CONTENT_DIR, dir)) do |path|
      full_path = File.join(CONTENT_DIR, dir, path)
      if Dir.exists? full_path
        pages = pages.concat(all_pages(File.join(dir, path)))
      else
        page = FrontMatterParser::Parser.parse_file(full_path)
        pages << { 
path: File.join(dir, path).gsub(/\.md$/, ''),
          title: page['title'],
          subtitle: page['subtitle']
        }
      end
    end
    pages
  end

  def page_content(path:, filepath:, page:)
    return auto_page(path:, filepath:) if page['auto'].present?
    return list_page(page['list']) if page['list'].present?
    Kramdown::Document.new(page.content).to_html.html_safe
  end

  def nav
    return @@nav if @@nav.present? && !Rails.env.development?

    nav_data = YAML.load_file('./app/lib/compendium-nav.yml').deep_symbolize_keys.freeze

    @@nav = nav_data[:pages].reduce([]) do |nav_items, path|
      nav_items << generate_nav_item(path)
    end
  end

  def generate_nav_item(path)
    return 'separator' if path == '---'

    path = path.gsub(/\.md$/, '')
    filepath = File.expand_path(File.join(CONTENT_DIR, path))
    dir = File.directory?(filepath)
    page = FrontMatterParser::Parser.parse_file(dir ? File.join(filepath, 'index.md') : "#{filepath}.md")

    nav_item = {
      dir:,
      path:,
      label: page['label'] || page['title'] || '(blank)'
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
