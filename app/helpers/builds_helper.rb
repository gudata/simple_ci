module BuildsHelper
  def highlight output
    return if output.blank?
    output.gsub!('success', content_tag(:span, 'success', class: 'build_success'))
    output.gsub!('error', content_tag(:span, 'error', class: 'build_error'))
    output.gsub!('failed', content_tag(:span, 'failed', class: 'build_failed'))
    output.html_safe
  end
end
