require 'rails_helper'

RSpec.describe UsersController, type: :controller do

	it "renders #new" do
		get :new
		expect(response.status).to eq(200)
	end

	it "should create user" do
		post :create, params: { user: { username: 'joe', password: '123456', password_confirmation: '123456' } }
		expect(User.count).to eq(1)
		expect(response.status).to eq(302)
		expect(response.header["Location"]).to eq('http://test.host/login')
		expect(flash[:success]).to eq("User has been created. Please, log in")
	end

	it "should not create user with wrong params" do
		post :create, params: { user: { username: 'joe', password: '123456', password_confirmation: 'wrong_password' } }
		expect(User.count).to eq(0)
	end

	it "re-renders the new method if user params are wrong" do
		post :create, params: { user: { username: 'joe', password: '123456', password_confirmation: 'wrong_password' } }
		expect(response.status).to eq(200)
		expect(response).to render_template(:new)
	end
	
	it "renders #show when user is logged in" do
		post :create, params: { user: { username: 'joe', password: '123456', password_confirmation: '123456' } }
		user = User.last
		user.authenticate('123456')
		session[:user_id] = user.id
		get :show, params: { id: user.id }
		expect(response.status).to eq(200)
		expect(response).to render_template(:show)
	end

	it "redirects to login path on get #show and user not logged in" do
		get :show
		expect(response.status).to eq(302)
		expect(response.header["Location"]).to eq('http://test.host/login')
	end

	it "redirects to root path on get users#index" do
		get :index
		expect(response.status).to eq(302)
		expect(response.header["Location"]).to eq('http://test.host/')
	end

	it "should raise error when try to delete user" do
		user = User.new(username: 'joe', password: '123456', password_confirmation: '123456')
		user.save
		expect{ delete :destroy, params: { id: user.id } }.to raise_error(ActionController::UrlGenerationError)
		expect(User.count).to eq(1)
	end
end
