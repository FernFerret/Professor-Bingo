class User < ActiveRecord::Base
	attr_accessible :username, :email, :password, :password_confirmation
	acts_as_authentic
	has_many :boards
	has_one :school
	has_many :professors
end
