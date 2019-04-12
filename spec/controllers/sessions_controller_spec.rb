require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

	it "renders #new" do
		get :new
		expect(response.status).to eq(200)
		expect(response.content_type).to eq "text/html"
	end

	it "should create session if user exists" do
		user = User.new(username: 'joe', password: '123456', password_confirmation: '123456')
		user.save
		post :create, params: { session: { username: 'joe', password: '123456' } }
		expect(response.status).to eq(302)
		expect(response.header["Location"]).to eq('http://test.host/')
	end

	it "should not create session if user doesn't exist" do
		post :create, params: { session: { username: 'joe', password: '123456' } }
		expect(response.status).to eq(302)
		expect(response.header["Location"]).to eq('http://test.host/login')
		expect(flash[:error]).to eq("Invalid username/password combination")
	end

	it "should not create session if password is wrong" do
		user = User.new(username: 'joe', password: '123456', password_confirmation: '123456')
		user.save
		post :create, params: { session: { username: 'joe', password: 'wrong_password' } }
		expect(response.status).to eq(302)
		expect(response.header["Location"]).to eq('http://test.host/login')
		expect(flash[:error]).to eq("Invalid username/password combination")
	end

	it "should not create session if username is empty" do
		user = User.new(username: 'joe', password: '123456', password_confirmation: '123456')
		user.save
		post :create, params: { session: { username: '', password: '123456' } }
		expect(response.status).to eq(302)
		expect(response.header["Location"]).to eq('http://test.host/login')
		expect(flash[:error]).to eq("Invalid username/password combination")
	end

	it "destroys session" do
		user = User.new(username: 'joe', password: '123456', password_confirmation: '123456')
		user.save
		post :create, params: { session: { username: 'joe', password: '123456' } }
		expect(response.status).to eq(302)
		expect(response.header["Location"]).to eq('http://test.host/')
		get :destroy
		expect(response.status).to eq(302)
		expect(response.header["Location"]).to eq('http://test.host/login')
	end
end
