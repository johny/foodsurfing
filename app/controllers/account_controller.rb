class AccountController < ApplicationController

  before_action :authenticate_user!


  def dashboard
  end

  def profile
    @user = current_user
  end

  def update

    @user = current_user

    if @user.update_attributes(user_params)
      flash[:notice] = "Profil zaktualizowany"
      redirect_to dashboard_path
    else
      flash.now[:error] = "Sprawdź poprawność danych"
      render action: "profile"
    end

  end


  private

    def user_params
      params.require(:user).permit(:name, :bio, :avatar)
    end

end
