module ReviewsHelper
  def review_button_or_form(movie)
    if current_user
      review = movie.reviews.new
      render "reviews/form", movie: movie, review: review
    else
      link_to "Write a review", new_movie_review_path(movie),
              class: "review"
    end
  end
end
