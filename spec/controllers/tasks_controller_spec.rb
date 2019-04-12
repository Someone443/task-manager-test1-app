require 'rails_helper'

RSpec.describe TasksController, type: :controller do

	it "redirects to login page on #new if not logged in" do
		get :new
		expect(response.status).to eq(302)
		expect(response.header["Location"]).to eq('http://test.host/login')
		expect(flash[:error]).to eq("Please, log in")		
	end

	it "should create task" do
		user = User.new(username: 'joe', password: '123456', password_confirmation: '123456')
		user.save
		user.authenticate('123456')
		session[:user_id] = user.id
		list = List.new(title: "List title", user_id: user.id)
		list.save
		post :create, params: { task: { title: "Task title", list_id: list.id } }, xhr: true
		expect(Task.count).to eq(1)
		expect(response.status).to eq(200)
		expect(response.content_type).to eq "text/javascript"
	end	

	it "should render edit" do
		user = User.new(username: 'joe', password: '123456', password_confirmation: '123456')
		user.save
		user.authenticate('123456')
		session[:user_id] = user.id
		list = List.new(title: "List title", user_id: user.id)
		list.save
		task = Task.new(title: "Task title", list_id: list.id)
		task.save
		get :edit, params: { id: task.id }, xhr: true
		expect(response.status).to eq(200)
		expect(response).to render_template(:edit)	
	end

	it "should update task" do
		user = User.new(username: 'joe', password: '123456', password_confirmation: '123456')
		user.save
		user.authenticate('123456')
		session[:user_id] = user.id
		list = List.new(title: "List title", user_id: user.id)
		list.save
		task = Task.new(title: "Task title", list_id: list.id)
		task.save
		put :update, params: { id: task.id, task: { title: "Task title updated" } }, xhr: true
		expect(response.status).to eq(200)
		expect(Task.find(task.id).title).to eq('Task title updated')	
	end

	it "should destroy task" do
		user = User.new(username: 'joe', password: '123456', password_confirmation: '123456')
		user.save
		user.authenticate('123456')
		session[:user_id] = user.id
		list = List.new(title: "List title", user_id: user.id)
		list.save
		task = Task.new(title: "Task title", list_id: list.id)
		task.save
		delete :destroy, params: { id: task.id }, xhr: true
		expect(response.status).to eq(200)
		expect(Task.count).to eq(0)	
	end

	it "should mark task done" do
		user = User.new(username: 'joe', password: '123456', password_confirmation: '123456')
		user.save
		user.authenticate('123456')
		session[:user_id] = user.id
		list = List.new(title: "List title", user_id: user.id)
		list.save
		task = Task.new(title: "Task title", list_id: list.id)
		task.save

		get :done, params: { id: task.id }, xhr: true
		expect(response.status).to eq(200)
		expect(Task.find(task.id).done).to eq(true)	
	end

	it "should mark task in progress" do
		user = User.new(username: 'joe', password: '123456', password_confirmation: '123456')
		user.save
		user.authenticate('123456')
		session[:user_id] = user.id
		list = List.new(title: "List title", user_id: user.id)
		list.save
		task = Task.new(title: "Task title", list_id: list.id)
		task.save

		get :in_progress, params: { id: task.id }, xhr: true
		expect(response.status).to eq(200)
		expect(Task.find(task.id).done).to eq(false)	
	end

	it "should set task order up" do
		user = User.new(username: 'joe', password: '123456', password_confirmation: '123456')
		user.save
		user.authenticate('123456')
		session[:user_id] = user.id
		list = List.new(title: "List title", user_id: user.id)
		list.save
		task_one = Task.new(title: "Task 1 title", list_id: list.id, order: 1)
		task_one.save
		task_two = Task.new(title: "Task 2 title", list_id: list.id, order: 2)
		task_two.save

		get :order_up, params: { id: task_two.id }, xhr: true
		expect(response.status).to eq(200)
		expect(Task.find(task_one.id).order).to eq(2)
		expect(Task.find(task_two.id).order).to eq(1)
	end

	it "should set task order down" do
		user = User.new(username: 'joe', password: '123456', password_confirmation: '123456')
		user.save
		user.authenticate('123456')
		session[:user_id] = user.id
		list = List.new(title: "List title", user_id: user.id)
		list.save
		task_one = Task.new(title: "Task 1 title", list_id: list.id, order: 1)
		task_one.save
		task_two = Task.new(title: "Task 2 title", list_id: list.id, order: 2)
		task_two.save	

		get :order_down, params: { id: task_one.id }, xhr: true
		expect(response.status).to eq(200)
		expect(Task.find(task_one.id).order).to eq(2)
		expect(Task.find(task_two.id).order).to eq(1)
	end
end
