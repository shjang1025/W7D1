class SessionsController < ApplicationController
    def new # HTML form
        @user = User.new
        render :new
    end

    def create # creates new session & matches session tokens
        incoming_username = params[:user][:username]
        incoming_password = params[:user][:password]
        @user = User.find_by_credentials(incoming_username, incoming_password)
        if @user
            login(@user)
            redirect_to cats_url
        else
            render :new
        end
    end

    def destroy # logouts user & unmatches session tokens
        log_out
        redirect_to new_session_url
    end
end