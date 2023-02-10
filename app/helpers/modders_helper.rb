module ModdersHelper

  def format_bio(bio)
    paragraphs = bio.split(/(\r\n|\r|\n)\1+/)
    paragraphs = paragraphs.filter { |p| p.match? /\S/ }
    paragraphs = paragraphs.map do |paragraph|
      html_escape(paragraph).gsub(/(?:\r\n|\r|\n)/, '<br>').html_safe
    end

    render 'bio', locals: { paragraphs: }
  end

end
