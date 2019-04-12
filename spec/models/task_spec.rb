require 'rails_helper'

RSpec.describe Task, type: :model do
	it "should not save task without title" do
		task = Task.new
		expect(task.save).to eq(false)
	end

	it "should not save task without list_id" do
		task = Task.new(title: 'test_task')
		expect(task.save).to eq(false)
	end

	it "should save valid task" do
		user = User.new(username: 'joe', password: '123456', password_confirmation: '123456')
		user.save
		list = List.new(title: 'test_list', user_id: user.id)
		list.save
		task = Task.new(title: 'test_task', list_id: list.id)
		expect(task.save).to eq(true)
	end
end