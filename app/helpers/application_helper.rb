module ApplicationHelper

  include ZurbHelper


  def build_actions build, show_show_action: true
    output = []
    stop = link_to(content_tag(:i, '', class: 'fi-stop'), [:stop, build.repository, build], method: :patch, class: 'button tiny secondary')
    start_new = link_to(content_tag(:i, '', class: 'fi-loop'), [:start_new, build.repository, build], method: :patch, class: 'button tiny secondary', title: 'Re-run this build')
    show = show_show_action ? link_to('Show '.html_safe + content_tag(:i, '', class: 'fi-book'), [build.repository, build], class: 'button tiny secondary') : ''

    case build.state_name
      # http://zurb.com/playground/foundation-icon-fonts-3
    when :pending
       # output << content_tag(:i, '', class: 'fi-clock')
     when :running
      output << stop
    when :failed
      output << show
      output << start_new
    when :unknown
      output << show
      output << start_new
    when :success
      output << show
      output << start_new
    end

    output.join(' ').html_safe
  end


  def build_time build
    return '---' unless build
    if build.total_time.present?
      build.total_time
    elsif build.started_at.present?
      distance_of_time_in_words(build.started_at, Time.now)
    end
  end

  def build_state build
    return content_tag(:i, '', class: 'fi-blind') unless build

    case build.state_name
    when :pending
      icon = 'fi-clock'
    when :running
      icon = 'fi-battery-half'
    when :failed
      icon = 'fi-skull' #  dislike
    when :unknown
      icon = 'fi-unlink'
    when :success
      icon = 'fi-check'
    end

    content_tag :i, '', class: icon
  end

  def class_for_commit commit
    return 'unknown' if commit.builds.empty?
    return commit.last_build.state_name
  end

end
