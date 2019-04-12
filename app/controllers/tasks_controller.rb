class TasksController < ApplicationController
	respond_to :html
	respond_to :js

	def new
	end

	def create
		@task = Task.new(task_params)
		all_tasks = Task.where(list_id: @task.list_id)
		order_array = []

		all_tasks.each { |e|  order_array << e.order }
		@task.order = order_array.max.nil? ? 1 : order_array.max + 1

		if @task.save
			flash.clear
			respond_with(@task)
		else
			flash[:error] = @task.errors.full_messages
			render :_form_error
		end
	end
	
	def edit
		@task = Task.find(params[:id])
	end

	def update
		@task = Task.find(params[:id])

		if @task.update(task_params)
			flash.clear
			respond_with(@task)
		else
			flash[:error] = @task.errors.full_messages
			render :_edit_form_error
		end
	end

	def destroy
		@task = Task.find(params[:id])
		@task.destroy
		respond_with(@task)
	end

	def done
		@task = Task.find(params[:id])
		@task.mark_done
	end

	def in_progress
		@task = Task.find(params[:id])
		@task.mark_in_progress
	end

	def order_up
		@task = Task.find(params[:id])
		all_tasks = Task.where(list_id: @task.list_id)

		unless all_tasks.count < 2 || all_tasks.first == @task 
			prev_task = all_tasks[all_tasks.index(@task) - 1]
			prev_task.order += 1
			prev_task.save!
			@task.order -= 1
			@task.save!
		end
	end
	
	def order_down
		@task = Task.find(params[:id])
		all_tasks = Task.where(list_id: @task.list_id)

		unless all_tasks.count < 2 || all_tasks.last == @task
			next_task = all_tasks[all_tasks.index(@task) + 1]
			next_task.order -= 1
			next_task.save!
			@task.order += 1
			@task.save!
		end
	end

	private

	def task_params
		params.require(:task).permit(:title, :deadline, :list_id)
	end
end
