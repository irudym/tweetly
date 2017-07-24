module ApplicationHelper
  def show_menu
    menu = [
        {
            text: 'subscriptions',
            icon: icon('envelope-open-o 2x'),
            href: new_subscription_path,
            color: 1
        },
        {
            text: 'manage',
            icon: icon('cog'),
            href: subscriptions_path,
            color: 2
        },
        {
            text: 'sign out',
            icon: icon('sign-out'),
            href: subscriptions_logout_path,
            color: 3
        }
    ]
    menu.inject('') do |acc, item|
      acc + "<div class='col text-center menu-item'>
                <a href='#{item[:href]}' class='menu-item#{item[:color]}'>
                  <div class='circle-button menu-button#{item[:color]}'>
                      #{item[:icon]}
                  </div>
                  <div class='menu-text menu-text-color#{item[:color]}'>
                      #{item[:text]}
                  </div>
                </a>
             </div>
            "
    end.html_safe
  end

  def show_error(error)
    "<div class='error-block'><h2>Error:</h2><p>#{error}</p></div>".html_safe if error
  end

  def show_notice(notice)
    html_text = ''
    if notice
      html_text = "<div class='info-block'><h2>Info:</h2><p>#{sanitize notice}</p></div>"
    end
    html_text.html_safe
  end

  def show_errors(object)
    html_str = ''
    if object.errors.any?
      messages = object.errors.full_messages.inject('') { |res, item |  res + "<li>#{item}</li>"}
      html_str = "<div class='error-block'>
                   <h2>#{pluralize(object.errors.count, 'Error')}</h2>
                    <p><ul>
                      #{messages}
                    </ul></p>
                  </div>"
    end
    html_str.html_safe
  end

end
