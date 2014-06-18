module SessionsHelper

	def sign_in(user)
		remember_token = User.new_remember_token
		cookies.permanent[:remember_token] = remember_token
		user.update_attribute(:remember_token, User.encrypt(remember_token))
		self.current_user = user  #assignment
	end

	def signed_in?
		!current_user.nil?
	end


	def current_user=(user)   #'=' in method name is special assignment
		@current_user = user
	end

	def current_user
		remember_token = User.encrypt(cookies[:remember_token])
		@current_user ||= User.find_by(remember_token: remember_token)
	end

	def current_user?(user)
		user == current_user
	end

	def sign_out
		current_user.update_attribute(:remember_token, User.encrypt(User.new_remember_token))
		cookies.delete(:remember_token)
		self.current_user = nil
	end

	def redirect_back_or(default)
		redirect_to(session[:return_to] || default)
			# Evaluates to 'session[:return_to'] unless it is nil
		session.delete(:return_to)
			# Remove the forwarding url, or else user would be forwarded to this page until
				# browser closed
	end

	def store_location
		session[:return_to] = request.url if request.get?
		# 'request.url' uses the request object to get url of the REQUESTED page
		#  If request is a 'get' create a :return_to key in session and pair it with 'request.url'
		# Limiting to 'get' requests avoids edge case of someone submitting a form when not logged 
		# in and user has deleted the remember token by hand before submitting form
	end
end
