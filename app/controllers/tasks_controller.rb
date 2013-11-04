class TasksController < ApplicationController
  before_filter :signed_in?
  before_action :set_task, only: [:show, :edit, :update, :destroy, :change_status]

  # GET /tasks
  # GET /tasks.json
  def index
    if params[:active_tag]
      @activeTag = params[:active_tag].to_i
    else
      @activeTag = 0
    end
    if params[:active_task]
      @task = Task.find(params[:active_task])
    end
    @tasks = current_user.tasks(@activeTag)
    @tags = current_user.tags

  end

  def change_status
    @task.is_complete = !@task.is_complete
    @task.save()
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
    respond_to do |format|
      format.json { render :json => {:success => true, :html => (render_to_string edit_task_path(@task))} }
      format.html { render :layout => !request.xhr? }
    end





  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(task_params)

    respond_to do |format|
      if @task.save
        format.html { redirect_to @task, notice: 'Task was successfully created.' }
        format.json { render action: 'show', status: :created, location: @task }
      else
        format.html { render action: 'new' }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to tasks_path, notice: 'Task was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.require(:task).permit(:user_id, :item, :is_complete, :deadline, :location)
    end

    def current_user
      current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
end
