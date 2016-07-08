class Recommendation < ActiveRecord::Base
	after_initialize :default_values

	def default_values
		self.opened ||= false
	end

	def get_user 
		return User.find self.user_id
	end
end
