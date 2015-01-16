require 'bcrypt'

class User

	include DataMapper::Resource

	attr_reader :password
	attr_accessor :password_confirmation

	property :id, Serial
	property :email, String, :unique => true

	property :password_digest, Text
	property :password_token, Text
	property :password_token_timestamp, DateTime


	validates_uniqueness_of :email
	validates_confirmation_of :password

	def password=(password)
		@password = password
		self.password_digest = BCrypt::Password.create(password)
	end

	def self.authenticate(email, password)
		user = first(:email => email)
		if user && BCrypt::Password.new(user.password_digest) == password
			user
		else
			nil
		end
	end

	def self.password_reset(email)
		user = first(:email => email)
		user.password_token = (1..64).map{('A'..'Z').to_a.sample}.join
		user.password_token_timestamp = Time.now
		user.save
	end

end