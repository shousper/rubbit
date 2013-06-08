module ApplicationHelper

  # Returns the Gravatar (http://gravatar.com/) for the given user.
  def gravatar_for(user, size = 50)
    gravatar_url = Gravatar.new(user.email).image_url({size: size, default: 'identicon'})
    image_tag(gravatar_url, alt: user.username, class: "gravatar")
  end

end
