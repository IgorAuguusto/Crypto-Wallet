class WelcomeController < ApplicationController
  def index
    cookies[:curso] = "Curso de Ruby on Rails [COOKIE]"
    session[:user_name] = "Igor Augusto Alves [SESSION]"
    @name = params[:name]
  end
end
