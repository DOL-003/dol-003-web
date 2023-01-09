class KnowledgeBaseController < ApplicationController

  CONTENT_DIR = File.join(File.expand_path('.'), 'app/views/knowledge_base/content')
  @@pages = {}
  @@menu = {}

  def show
    return not_found unless flag_enabled? :knowledge_base

    page = page_data(params[:path] || 'index')
    return not_found if page.blank?

    @title = page[:title]
    @description = page[:description]
    @content = page[:content]
    @menu = menu_data
  end

  private

  def page_data(path)
    return @@pages[path] if @@pages[path].present? && !Rails.env.development?

    filepath = "#{File.expand_path(File.join(CONTENT_DIR, path))}.md"
    return nil unless filepath.start_with? CONTENT_DIR
    return nil unless File.file? filepath

    page = FrontMatterParser::Parser.parse_file(filepath)

    @@pages[path] = {
      title: page['title'],
      description: page['description'],
      content: Kramdown::Document.new(page.content).to_html.html_safe
    }
  end

  def menu_data
    return @@menu if @@menu.present? && !Rails.env.development?

    @@menu = YAML.load(File.read('./app/lib/kb-menu.yml')).deep_symbolize_keys.freeze
  end

end
