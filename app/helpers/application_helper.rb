# frozen_string_literal: true
require "redcarpet"
require 'redcarpet/render_strip'
require "coderay"

module ApplicationHelper
  def row_background_color(item)
    if item.archived
      "group-row-acvhived"
    elsif item.remark
      "group-row-remark"
    else
      ""
    end
  end

  class HTMLwithCoderay < Redcarpet::Render::HTML
    def block_code(code, language)
      language = language.split(':')[0]

      case language.to_s
      when 'rb'
        lang = 'ruby'
      when 'yml'
        lang = 'yaml'
      when 'css'
        lang = 'css'
      when 'html'
        lang = 'html'
      when ''
        lang = 'md'
      else
        lang = language
      end

      CodeRay.scan(code, lang).div
    end
  end

  def markdown(text)
    html_render = HTMLwithCoderay.new(filter_html: true, hard_wrap: true)
    options = {
        autolink: true,
        space_after_headers: true,
        no_intra_emphasis: true,
        fenced_code_blocks: true,
        tables: true,
        hard_wrap: true,
        xhtml: true,
        lax_html_blocks: true,
        strikethrough: true
    }
    markdown = Redcarpet::Markdown.new(html_render, options)
    markdown.render(text)
  end

  def markdown_to_plain_text(text)
    renderer = Redcarpet::Markdown.new(Redcarpet::Render::StripDown)
    renderer.render(text)
  end

end
