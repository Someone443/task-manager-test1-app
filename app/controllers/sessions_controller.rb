class SessionsController < ApplicationController
	skip_before_action :require_valid_user!, except: [:destroy]

	def new
	end

	def create
		reset_session
		@user = User.find_by(username: session_params[:username])
		if @user && @user.authenticate(session_params[:password])
			session[:user_id] = @user.id
			redirect_to root_path
		else
			flash[:error] = 'Invalid username/password combination'
			redirect_to login_path
		end
	end

	def destroy
		reset_session
		redirect_to login_path
	end

	private

	def session_params
		params.require(:session).permit(:username, :password)
	end
end
