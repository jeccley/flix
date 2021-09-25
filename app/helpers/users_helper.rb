module UsersHelper
  GRAVATAR_URL = "http://secure.gravatar.com/avatar/"

  def profile_image(user, size = 80)
    url = "#{GRAVATAR_URL}#{user.gravatar_id}?s=#{size}"
    image_tag url, alt: user.name
  end
end
