class TasksController < ApplicationController
  
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :require_user_logged_in, only: [:index, :show]
  before_action :check_user, only:[:show,:edit,:update,:destroy]

  def index
    @user = User.find(session[:user_id])
    @tasks = @user.tasks.page(params[:page]).per(10)
    #@tasks = Task.all.page(params[:page]).per(10)
  end

  def show
  end

  def new
    @task = Task.new
  end

  def create
    @task = current_user.tasks.build(task_params)
    
    if @task.save
      flash[:success]  = "Taskが正常に投稿されました"
      redirect_to @task
    else
      flash.now[:danger] = "Taskが投稿されませんでした"
      render :new
    end
  end
  
  def edit
  end

  def update
    if @task.update(task_params)
      flash[:success] = 'Task は正常に更新されました'
      redirect_to @task
    else
      flash.now[:danger] = 'Taskは更新されませんでした'
      render :edit
    end
  end

  def destroy
    @task.destroy

    flash[:success] = 'Task は正常に削除されました'
    redirect_to tasks_url
  end
end

private

def set_task
  @task = Task.find(params[:id])
end

#Redirection For dening illegal access
def check_user
  unless Task.find(params[:id]).user_id == session[:user_id]
  redirect_to controller: 'users', action: 'show'
  end
end

#Strong Parameter
def task_params
  params.require(:task).permit(:content, :status)
end

