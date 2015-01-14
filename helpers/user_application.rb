module UserSession
	
	def current_user
		@current_user ||=User.get(session[:user_id]) if session[:user_id]
	end

end

module SessionHelpers

	def sign_up(email = "alice@example.com", 
							password = "oranges!",
							password_confirmation = "oranges!")
		visit '/users/new'
		expect(page.status_code).to eq 200
		fill_in :email, :with => email
		fill_in :password, :with => password
		fill_in :password_confirmation, :with => password_confirmation
		click_button "Sign Up"
	end

	def sign_in(email, password)
		visit '/sessions/new'
		fill_in 'email', :with => email
		fill_in 'password', :with => password
		click_button "Sign In"
	end

end
