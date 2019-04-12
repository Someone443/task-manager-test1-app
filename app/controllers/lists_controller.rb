class ListsController < ApplicationController
	respond_to :html
	respond_to :js

	def new
	end

	def create
		@list = List.new(list_params)

		if @list.save
			flash.clear
			respond_with(@list)
		else
			flash[:error] = @list.errors.full_messages
			render :_list_form_error
		end
	end

	def edit
		@list = List.find(params[:id])
	end

	def update
		@list = List.find(params[:id])

		if @list.update(list_params)
			flash.clear
			respond_with(@list)
		else
			flash[:error] = @list.errors.full_messages
			render :_edit_list_form_error
		end
	end

	def destroy
		@list = List.find(params[:id])
		@list.destroy
		respond_with(@list)
	end

	private

	def list_params
		params.require(:list).permit(:title, :user_id)
	end
end
