module ApplicationHelper
  def render_turbo_stream_flash_messages
    turbo_stream.prepend "flash", partial: "layouts/flash"
  end

  def nav_link(text, path, css_class)
    options = yield if block_given?
    content_tag(:li, { class: 'nav-item' }) do
      link_to text, path, { data: options, class: "#{css_class} #{current_page?(path) ? 'active' : ''}" }
    end
  end
end
