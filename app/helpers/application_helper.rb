module ApplicationHelper
  # I placed this in the ApplicationHelper rather than MovieHelper module as advised by PragStudio
  # because I want it to work with all the entries in the Nav Bar and not just the movie filters.
  def nav_link_to(text, url)
    if current_page?(url)
      link_to text, url, class: "active"
    else
      link_to text, url
    end
  end
end
