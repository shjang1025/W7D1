class ApplicationController < ActionController::Base
    before_action :require_logged_out
    # C R R L L L
    helper_method :current_user, :logged_in?

    def current_user
        @current_user ||= User.find_by(session_token: session[:session_token])
    end

    def require_logged_in
        redirect_to new_session_url if !logged_in?
    end

    def require_logged_out
        redirect_to cats_url if logged_in?
    end

    def login(user)
        session[:session_token] = user.reset_session_token!
    end

    def logged_in?
        !!current_user
    end

    def log_out
        if current_user
            current_user.reset_session_token!
            session[:session_token] = nil
            @current_user = nil
        end
    end
end