module MoviesHelper
  def total_gross(movie)
    movie.flop? ? "Flop!" : number_to_currency(movie.total_gross, precision: 0)
  end

  def year_of(movie)
    movie.released_on.year
  end

  # This helper was replaced with star characters in the bonus exercise - much nicer!
  # def average_stars(movie)
  #   if movie.average_stars.zero?
  #     content_tag(:strong, "No reviews")
  #   else
  #     # pluralize(number_with_precision(movie.average_stars, precision: 1), "star")
  #     "*" * movie.average_stars.round
  #   end
  # end
end
