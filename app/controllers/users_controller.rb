require 'rack-flash'

class UsersController < ApplicationController
  use Rack::Flash
  
  get '/login' do
    if logged_in?
      redirect '/tasks'
    else
      erb :'users/login'
    end
  end

  get '/logout' do
    if logged_in?
      session.clear
      redirect '/login'
    else
      redirect '/login'
    end
  end

  get '/signup' do
    if logged_in?
      redirect '/tasks'
    else
      erb :'users/signup'
    end
  end

  post '/signup' do
    if User.find_by(username: params[:username]) 
      redirect '/signup'
    elsif !params[:username].empty? && !params[:password].empty? 
      @user = User.create(params)
      session[:user_id] = @user.id
      redirect to '/tasks'
    else
      redirect '/signup'
    end
  end

  post '/login' do
    user = User.find_by(:username => params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect '/tasks'
    else
      redirect '/login'
    end
  end
end
