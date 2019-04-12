require 'rails_helper'

RSpec.describe List, type: :model do
	it "should not save list without title" do
		list = List.new
		expect(list.save).to eq(false)
	end

	it "should not save list without user_id" do
		list = List.new(title: 'test_list')
		expect(list.save).to eq(false)
	end

	it "should save valid list" do
		user = User.new(username: 'joe', password: '123456', password_confirmation: '123456')
		user.save
		list = List.new(title: 'test_list', user_id: user.id)
		expect(list.save).to eq(true)
	end	
end