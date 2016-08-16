require 'rack-flash'

class TasksController < ApplicationController
  use Rack::Flash

  get '/tasks' do
    if logged_in? 
      # binding.pry
      @tasks = current_user.tasks
      erb :'tasks/index'
    else
      redirect to '/login'
    end   
  end

  get '/tasks/new' do
    if logged_in? 
      erb :'tasks/create'
    else
      redirect to '/login'
    end   
  end

  get '/tasks/:id' do
    if !logged_in? 
      redirect to '/login'
    elsif current_user.tasks.find_by(id: params[:id])
      @task = current_user.tasks.find_by(id: params[:id])
      erb :'tasks/show'
    end
  end

  get '/tasks/:id/edit' do
    if logged_in? 
      @task = current_user.tasks.find_by(id: params[:id])
      if @task 
        erb :'tasks/edit'
      else
        redirect to '/tasks'
      end
    else
      redirect to '/login'
    end
  end

  post '/new' do
    if logged_in? && !params[:content].empty? 
      task = Task.create(params)
      task.user_id = current_user.id
      current_user.tasks << task
      flash[:message] = "Successfully created a task."
      redirect "/tasks/#{task.id}"
    elsif logged_in? && params[:content].empty?
      redirect to '/tasks/new'
    else
      redirect to '/login'
    end   
  end

  patch '/tasks/:id' do
    if params[:content].empty? || params[:name].empty?
      flash[:message] = "Task name or task content can not be empty."
      redirect to "tasks/#{params[:id]}/edit"
    else
      @task = current_user.tasks.find_by(id: params[:id])
      @task.content = (params[:content])
      @task.name = (params[:name])
      @task.save
      flash[:message] = "Successfully edited the task."
      redirect "/tasks/#{@task.id}"
    end
  end

  delete '/tasks/:id/delete' do
    if current_user.tasks.find_by(id: params[:id]) && session[:user_id] = current_user.id
       # @task = Task.find_by(params[:id])
       # @task.delete
      Task.destroy(params[:id])
       flash[:message] = "Successfully deleted the task."
       redirect to '/tasks'
     else 
       redirect to '/login'
    end
  end
end
