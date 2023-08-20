class CompendiumController < ApplicationController

  CONTENT_DIR = File.join(File.expand_path('.'), 'app/views/compendium/content')
  @@pages = {}
  @@menu = {}

  def show
    return not_found unless flag_enabled? :compendium

    page = page_data(params[:path] || 'index')
    return not_found if page.blank?

    @title = page[:title]
    @subtitle = page[:subtitle]
    @content = page[:content]
    @menu = menu_data
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

  def menu_data
    return @@menu if @@menu.present? && !Rails.env.development?

    menu = YAML.load(File.read('./app/lib/compendium-menu.yml')).deep_symbolize_keys.freeze

    @@menu = parse_item(menu, '/compendium')
  end

  def parse_item(item, path)
    return item unless item.is_a?(Hash)

    item.reduce([]) do |data, (slug, subitem)|
      subitem_data = {
        path: File.join(path, slug.to_s)
      }

      if subitem.nil?
        subitem_data = {
          separator: true
        }
      elsif subitem.is_a?(String)
        subitem_data[:label] = subitem
      elsif subitem.is_a?(Hash)
        if subitem[:label].blank?
          begin
            page = FrontMatterParser::Parser.parse_file(File.expand_path(File.join(CONTENT_DIR, subitem_data[:path].gsub(/^\/compendium/, ''), 'index.md')))
            subitem_data[:label] = page['label'] || page['title']
          rescue
            subitem_data[:label] = '(blank)'
          end
        else
          subitem_data[:label] = subitem[:label]
        end

        if subitem[:auto]
          children_data = {}
          Dir.each_child(File.expand_path(File.join(CONTENT_DIR, subitem_data[:path].gsub(/^\/compendium/, '')))) do |filename|
            next if filename == 'index.md'
            page = FrontMatterParser::Parser.parse_file(File.expand_path(File.join(CONTENT_DIR, subitem_data[:path].gsub(/^\/compendium/, ''), filename)))
            children_data[filename.gsub(/\.md$/, '')] = page['label'] || page['title']
          end
          subitem_data[:children] = parse_item(children_data.sort_by { |slug, title| title }.to_h, File.join(path, slug.to_s))
        else
          subitem_data[:children] = parse_item(subitem.except(:auto, :label), File.join(path, slug.to_s))
        end
      end

      data << subitem_data
      data
    end
  end

end
