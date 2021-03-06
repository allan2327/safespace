require "ask_awesomely"
require 'bio_typeform'
require 'httparty'
class IntroController < ApplicationController
	before_action :set_content

	def set_content
		@content = Content.first
	end

	def info
	    render "info"
	end

	def quiz
		@quiz = Quiz.new
	    redirect_to new_quiz_path
	end

	def liability
	    render "liability"
	end

	def create_bio
		@typeform = BioTypeform.build(current_user)
		@typeform.instance_variable_get(:@structure).instance_variable_get(:@state)[:tags][0] = current_user.id.to_s
		url = 'https://api.typeform.io/latest/forms'
		response = HTTParty.post(url, 
			:body => @typeform.to_json, 
			:headers => { 'Content-Type' => 'application/json', 'X-API-TOKEN' => TYPEFORM_IO_API_KEY } )
		body = JSON.parse(response.body)
		@typeform.instance_variable_set(:@id, body["id"])
		@typeform.instance_variable_set(:@links, body["_links"])
		@typeform.instance_variable_set(:@public_url, body["_links"][1]["href"])
		# body["_links"][1]["href"]
		# 'https://sagangwee.typeform.com/to/uOcIgm'
		# 'https://forms.typeform.io/to/6B9dQxKUq9'
		# respond_to do |format| 
		# 	format.json { render json: @typeform.to_json }
		# end
		render "create_bio", typeform: @typeform
	end

end
