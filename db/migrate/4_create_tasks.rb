class CreateTasks < ActiveRecord::Migration[5.2]
	def change
		create_table :tasks do |t|
			t.references :list, foreign_key: true
			t.text :title, null: false
			t.integer :order
			t.timestamp :deadline
			t.boolean :done, null: false, default: false

			t.timestamps
		end
	end
end
