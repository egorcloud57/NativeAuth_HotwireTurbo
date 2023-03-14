module Auth
  extend ActiveSupport::Concern

  included do
    def log_in(user)
      session[:user_id] = user.id
    end

    def current_user
      if (user_id = session[:user_id])
        @current_user ||= User.find_by(id: user_id)
      elsif (user_id = cookies.signed[:user_id]) # signed автоматически делает рехеш атрибута куки(у нас это user_id)
        user = User.find_by(id: user_id)
        if user && user.authenticated?(:remember, cookies[:remember_token])
          log_in user
          @current_user = user
        end
      end
    end

    def current_user?(user)
      user == current_user
    end

    def logged_in?
      current_user.present?
    end

    def store_location
      session[:forwarding_url] = request.url if request.get?
    end

    def redirect_back_or(default)
      redirect_to(session[:forwarding_url] || default)
      session.delete(:forwarding_url)
    end

    def log_out
      forget(current_user)
      session.delete(:user_id)
      @current_user = nil
    end

    def remember(user)
      user.remember
      # signed[:user_id] - автоматически хеширует атрибут id пользователя. User.find_by(id: cookies.signed[:user_id]) - дехеширует
      cookies.permanent.signed[:user_id] = user.id
      cookies.permanent[:remember_token] = user.remember_token # так же сохраняем токен в куки
    end

    def forget(user)
      user.forget_user
      cookies.delete(:user_id)
      cookies.delete(:remember_token)
    end
  end

  class_methods do; end
end