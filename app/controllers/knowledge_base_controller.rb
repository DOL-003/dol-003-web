class KnowledgeBaseController < ApplicationController

  CONTENT_DIR = File.join(File.expand_path('.'), 'app/views/knowledge_base/content')
  @@pages = {}

  def show
    return not_found unless flag_enabled? :knowledge_base

    page = page_data(params[:path] || 'index')
    return not_found if page.blank?

    @title = page[:title]
    @description = page[:description]
    @content = page[:content]
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
      content: CommonMarker.render_html(page.content, [
        :DEFAULT
      ]).html_safe
    }
  end

end
