require 'rails_helper'

RSpec.describe User, type: :model do
	context 'when register' do
		it "should not save user without username" do
			user = User.new
			expect(user.save).to eq(false)
		end

		it "should not save user without password" do
			user = User.new(username: 'john')
			expect(user.save).to eq(false)
		end

		it "should not save user with empty password" do
			user = User.new(username: 'john', password: '')
			expect(user.save).to eq(false)
		end
		
		it "should not save user with too short password" do
			user = User.new(username: 'john', password: '123')
			expect(user.save).to eq(false)
		end

		it "should not save user if password confirmation doesn't match" do
			user = User.new(username: 'joe', password: '123456', password_confirmation: 'nomatch')
			expect(user.save).to eq(false)
		end

		it "should save user with valid username, password and password confirmation" do
			user = User.new(username: 'joe', password: '123456', password_confirmation: '123456')
			expect(user.save).to eq(true)
		end

		it "should not save user if username has already been taken" do
			user = User.new(username: 'joe', password: '123456', password_confirmation: '123456')
			user.save		
			new_user = User.new(username: 'joe', password: 'new_password', password_confirmation: 'new_password')
			expect(new_user.save).to eq(false)
		end
	end
	context 'when log in' do
		it "should authenticate user with correct password" do
			user = User.new(username: 'joe', password: '123456', password_confirmation: '123456')
			user.save		
			expect(user.authenticate('123456')).to eq(user)
		end

		it "should not authenticate user with wrong password" do
			user = User.new(username: 'joe', password: '123456', password_confirmation: '123456')
			user.save		
			expect(user.authenticate('wrong_password')).to eq(false)
		end
	end
end