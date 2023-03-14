class AccountActivationsController < MainController
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.update(activated: true, activated_at: Time.zone.now)
      log_in user
      flash[:success] = "Аккаунт активирован!"
      redirect_to user
    else
      flash[:danger] = "Недействительная ссылка активации"
      redirect_to root_url
    end
  end
end
