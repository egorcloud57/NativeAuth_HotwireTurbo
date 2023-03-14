class PasswordResetsController < MainController
  before_action :find_user!, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new; end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash.now[:info] = "Электронное письмо отправлено с инструкциями по сбросу пароля"
    else
      flash.now[:danger] = "Адрес электронной почты не найден"
    end
  end

  def edit; end

  def update
    if password_blank?
      flash.now[:danger] = "Пароль не может быть пустым"
    elsif @user.update(user_params)
      log_in @user
      redirect_back_or @user
      flash[:success] = "Пароль был сброшен."
    else
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def password_blank?
    params[:user][:password].blank?
  end

  def find_user!
    @user = User.find_by(email: params[:email])
  end

  def valid_user
    redirect_to root_url unless (@user && @user.activated? && @user.authenticated?(:reset, params[:id]))
  end

  def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = "Срок действия сброса пароля истек."
      redirect_to new_password_reset_url
    end
  end
end
