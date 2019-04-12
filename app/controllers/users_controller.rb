class UsersController < ApplicationController
	skip_before_action :require_valid_user!, except: [:show, :show_list_form]		
	before_action :reset_session, except: [:show, :show_list_form]

	respond_to :html
	respond_to :js

	def index
		redirect_to root_path
	end

	def show
		flash.clear
		respond_with(@user)
	end

	def new
		@user = User.new
	end

	def create
		@user = User.new(user_params)

		if @user.save
			flash[:success] = 'User has been created. Please, log in'
			redirect_to login_path
		else
			render :new
		end
	end

	def show_list_form
		@user = User.find(params[:id])
		respond_with(@user)
	end

	private

	def user_params
		params.require(:user).permit(:username, :password, :password_confirmation)
	end
end
