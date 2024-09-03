class CompendiumController < ApplicationController

  def show
    return not_found unless flag_enabled? :compendium

    path = params[:path] || 'index'
    slug = File.basename(path)

    redirect_path = "#{File.expand_path(File.join(Compendium::CONTENT_DIR, slug))}.redirect"
    return redirect_to File.read(redirect_path).strip if File.exists? redirect_path

    filepath = "#{File.expand_path(File.join(Compendium::CONTENT_DIR, slug))}.md"
    return not_found unless filepath.starts_with? Compendium::CONTENT_DIR
    return not_found unless File.exists? filepath

    page = FrontMatterParser::Parser.parse_file(filepath)

    add_recent_slug(slug)

    @compendium = true
    @nav = nav
    @title = RubyPants.new(page['title']).to_html.html_safe
    @subtitle = page['subtitle'].present? ? RubyPants.new(page['subtitle']).to_html.html_safe : nil
    @description = @subtitle.present? ? "#{@subtitle} The GameCube Controller Compendium is a hub for GCC modding knowledge." : nil
    @content = page_content(path:, filepath:, page:)
    @stub = page['stub'].present?
    @notices = page['notice'].present? ? [page['notice']] : page['notices']
    @path = "#{path}.md"
    @current_path = "/#{path}"
    @slug = slug
  end

  private

  def tag_page(tag:, sort:, path:)
    pages = Compendium.all_pages.filter { |page| (page[:tags] || []).include? tag }
    pages = pages.sort_by { |page| page[sort.to_sym] } if sort.present?
    pages = pages.map do |page|
      page[:path] = File.join(path, page[:slug])
      page
    end
    render_to_string 'auto_page', layout: false, locals: { subpages: pages }
  end

  def page_content(path:, filepath:, page:)
    return tag_page(tag: page['tag'], sort: page['sort'], path:) if page['tag'].present?
    Kramdown::Document.new(page.content).to_html.html_safe
  end

  def nav
    YAML.load_file('./app/lib/compendium-nav.yml').deep_symbolize_keys.freeze[:nav].map { |item| generate_nav_item(item) }
  end

  def generate_nav_item(item_data, path = '')
    return 'separator' if item_data == '---'

    nav_item = {}

    case item_data
    when String
      nav_item[:slug] = item_data
    when Hash
      nav_item[:slug] = item_data.keys.first.to_s

      case item_data.values.first
      when String
        # The value is a label
        nav_item[:label] = item_data.values.first
      when Array
        # The value is the children
        nav_item[:children] = item_data.values.first
      when Hash
        # The values are explicitly mapped out in a hash
        details = item_data.values.first
        nav_item[:label] = details[:label] if details[:label].present?
        nav_item[:children] = details[:children] if details[:children].present?
        nav_item[:sort] = details[:sort] if details[:sort].present?
      end
    end

    nav_item[:path] = File.join(path, nav_item[:slug]).gsub(%r{^/+}, '')

    unless nav_item[:label].present?
      filepath = File.expand_path(File.join(Compendium::CONTENT_DIR, nav_item[:slug]))
      page = FrontMatterParser::Parser.parse_file("#{filepath}.md")

      nav_item[:label] = page['title'] || '(no title)'
    end

    if nav_item[:children].present?
      nav_item[:children] = nav_item[:children].map { |item_data| generate_nav_item(item_data, File.join(path, nav_item[:slug])) }.compact
      nav_item[:children] = nav_item[:children].sort_by { |child_item| child_item[nav_item[:sort].to_sym] } if nav_item[:sort].present?
    end

    nav_item

  end

end
