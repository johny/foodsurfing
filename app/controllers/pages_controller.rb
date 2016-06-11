class PagesController < ApplicationController


  def index

    @meals = Meal.all

    @meals_json = @meals.map{ |meal|
      {
        name: meal.name,
        url: meal_url(meal),
        lat: meal.user.latitude,
        lng: meal.user.longitude
      }
    }.to_json

    @special = @meals.in_groups(2, false)[0]
    @latest = @meals.in_groups(2, false)[1]

  end

  def landing
    render layout: 'landing'
  end

  def about
  end

  def contact
  end


end
