class Task < ApplicationRecord
	validates :title, presence: true
	validates :title, format: { with: /\s*\S+\s*/ }
	belongs_to :list

	default_scope { order(order: :asc) }

	def mark_done
		self.update_attribute(:done, true)
	end

	def mark_in_progress
		self.update_attribute(:done, false)
	end
end
