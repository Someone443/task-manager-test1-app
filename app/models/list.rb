class List < ApplicationRecord
	validates :title, presence: true
	validates :title, format: { with: /\s*\S+\s*/ }

	belongs_to :user
	has_many :tasks, dependent: :destroy
end
