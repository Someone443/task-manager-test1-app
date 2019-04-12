class User < ApplicationRecord
	has_secure_password
	validates :username, :presence => true, :uniqueness => true
	validates :password, length: { minimum: 6 }

	has_many :lists, dependent: :destroy
	has_many :tasks, through: :lists
end
