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

module SendEmail

	def send_simple_message(email, text)
	  RestClient.post "https://api:key-8422790f54da4af4960c1293da5262eb"\
	  "@api.mailgun.net/v2/sandbox7760c7a3adab44adb4b6fe0e23f6c8ea.mailgun.org/messages",
	  :from => "Mailgun Sandbox <postmaster@sandbox7760c7a3adab44adb4b6fe0e23f6c8ea.mailgun.org>",
	  :to => email,
	  :subject => "Forgotten Password",
	  :text => text
	end

end
