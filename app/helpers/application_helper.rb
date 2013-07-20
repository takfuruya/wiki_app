require 'redcarpet'

module ApplicationHelper
  def assign_view_specific_stylesheets(*files)
    content_for(:view_specific_stylesheets) { stylesheet_link_tag(*files) }
  end

  def assign_view_specific_javascripts(*files)
    content_for(:view_specific_javascripts) { javascript_include_tag(*files) }
  end

  class HTMLwithPygments < Redcarpet::Render::HTML
    def block_code(code, language)
      Pygments.highlight(code, lexer: language)
    end
  end

  def markdown(text)
    options = {
      no_intra_emphasis: true,
      fenced_code_blocks: true,
      autolink: true,
      disable_indented_code_blocks: true,
      strikethrough: true,
      lax_spacing: true,
      space_after_headers: true,
      underline: true,
      highlight: true
    }
    renderer = HTMLwithPygments.new(hard_wrap: true)
    md = Redcarpet::Markdown.new(renderer, options)
    md.render(text).html_safe
  end
end
