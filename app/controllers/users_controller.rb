class UsersController < MainController
  before_action :find_user!, only: [:show]
  before_action :logged_in_user, only: [:show]
  before_action :correct_user, only: [:show]

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.account_activation(@user).deliver_now
      respond_to do |f|
        f.turbo_stream { flash.now[:info] = "Пожалуйста, проверьте свою электронную почту, чтобы активировать учетную запись." }
      end
    else
      render :new
    end
  end

  private

  def find_user!
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
