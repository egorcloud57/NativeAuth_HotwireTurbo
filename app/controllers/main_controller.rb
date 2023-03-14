class MainController < ApplicationController
  include Auth

  helper_method :logged_in?, :current_user

  private

  def assign_sender_to_model(model)
    params[model][:user_id] = current_user.id
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Пожалуйста, войдите."
      redirect_to new_session_path
    end
  end

  def correct_user
    user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(user)
  end
end
