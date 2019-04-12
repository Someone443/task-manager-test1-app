require 'rails_helper'

RSpec.describe ListsController, type: :controller do

	it "redirects to login page on #new if not logged in" do
		get :new
		expect(response.status).to eq(302)
		expect(response.header["Location"]).to eq('http://test.host/login')
		expect(flash[:error]).to eq("Please, log in")		
	end

	it "should create list" do
		user = User.new(username: 'joe', password: '123456', password_confirmation: '123456')
		user.save
		user.authenticate('123456')
		session[:user_id] = user.id

		post :create, params: { list: { title: "List title", user_id: user.id } }, xhr: true
		expect(List.count).to eq(1)

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
		get :edit, params: { id: list.id }, xhr: true
		expect(response.status).to eq(200)
		expect(response).to render_template(:edit)	
	end

	it "should update list" do
		user = User.new(username: 'joe', password: '123456', password_confirmation: '123456')
		user.save
		user.authenticate('123456')
		session[:user_id] = user.id
		list = List.new(title: "List title", user_id: user.id)
		list.save
		put :update, params: { id: list.id, list: { title: "List title updated" } }, xhr: true
		expect(response.status).to eq(200)
		expect(List.find(list.id).title).to eq('List title updated')	
	end

	it "should destroy list" do
		user = User.new(username: 'joe', password: '123456', password_confirmation: '123456')
		user.save
		user.authenticate('123456')
		session[:user_id] = user.id
		list = List.new(title: "List title", user_id: user.id)
		list.save
		delete :destroy, params: { id: list.id }, xhr: true
		expect(response.status).to eq(200)
		expect(List.count).to eq(0)	
	end

	it "should destroy associated tasks if list is destroyed" do
		user = User.new(username: 'joe', password: '123456', password_confirmation: '123456')
		user.save
		user.authenticate('123456')
		session[:user_id] = user.id
		list = List.new(title: "List title", user_id: user.id)
		list.save
		task = Task.new(title: "Task title", list_id: list.id)
		task.save
		delete :destroy, params: { id: list.id }, xhr: true
		expect(response.status).to eq(200)
		expect(List.count).to eq(0)
		expect(Task.find_by(list_id: list.id)).to be_nil	
	end	
end