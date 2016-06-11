class MealSharesController < ApplicationController

  before_action :authenticate_user!, only: [:create, :quit]

  def new
    @meal = Meal.find(params[:meal_id])
    @share = MealShare.new

    if current_user == @meal.user
      flash[:error] = "Nie możesz zamówić swojego posiłku"
      redirect_to meal_path(@meal)
    end

    unless user_signed_in?
      session[:join_meal_id] = @meal.id
      authenticate_user!
    end

  end


  def create
    @meal = Meal.find(params[:meal_id])
    @share = MealShare.new(meal_share_params)

    @share.user = current_user
    @share.meal = @meal

    if @share.save
      flash[:notice] = "Zapisaliśmy Twoje zamówienie"
      redirect_to meal_path(@meal)
    else
      flash.now[:error] = "Sprawdź poprawność formularza"
      render action: "new"
    end
  end

  def quit
    @meal = Meal.find(params[:meal_id])

    @share = @meal.meal_shares.where(user_id: current_user.id)

    if @meal.meal_shares.delete(@share)
      flash[:notice] = "Wypisałeś się!"
      redirect_to meal_path(@meal)
    end


  end


  private

    def meal_share_params
      params.require(:meal_share).permit(:ordered_portions, :portions)
    end

end
