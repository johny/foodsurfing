class MealsController < ApplicationController

  before_action :authenticate_user!, only: [:edit, :update]

  def new
    @meal = Meal.new
    @user = User.new unless user_signed_in?
  end

  def show
    @meal = Meal.find params[:id]
  end

  def create

    @meal = Meal.new(meal_params)

    if user_signed_in?
      @meal.user = current_user

      if @meal.save
        flash[:notice] = "Twój posiłek został dodany"
        redirect_to dashboard_path
      else
        flash[:error] = "Sprawdź poprawność formularza!"
        render action: "new"
      end
    else
      @user = User.new(user_params)
      @user.address_required = true

      if @user.valid? && @meal.valid?
        @meal.user = @user
        @meal.save
        @user.save
        sign_in @user

        flash[:notice] = "Twój posiłek został dodany"
        redirect_to dashboard_path
      else
        flash[:error] = "Sprawdź poprawność formularza!"
        render action: "new"
      end
    end

  end

  def edit
    @meal = current_user.meals.find(params[:id])
  end

  def update
    @meal = current_user.meals.find(params[:id])

    if @meal.update_attributes(meal_params)
      flash[:notice] = "Danie zaktualizowane"
      redirect_to dashboard_path
    else
      flash.now[:error] = "Sprawdź poprawność danych"
      render action: "edit"
    end
  end

  private

    def meal_params
      params.require(:meal).permit(:name, :description, :ingredients, :served_at, :cuttoff_time, :portions, :price_per_portion, :street_address, :city, :picture)
    end

    def user_params
      params.require(:user).permit(:name, :email, :password, :bio, :street_address, :city, :latitude, :longitude)
    end

end
