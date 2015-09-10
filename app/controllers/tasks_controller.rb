class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = Task.all
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
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @user = User.find(params[:user_id])
    @list = List.find(params[:list_id])
    @task = Task.new(name: params[:task][:name], status: 'unfinished', priority: (@list.tasks.size+1), list_id: params[:list_id])
    @name = params[:task][:name]
    respond_to do |format|
        if params[:task][:name].blank?
            format.js
        else
          if @task.save
            format.html { redirect_to @task, notice: 'Task was successfully created.' }
            format.json { render :show, status: :created, location: @task }
          else
            format.html { render :new }
            format.json { render json: @task.errors, status: :unprocessable_entity }
          end
            format.js
        end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def done
    @task = Task.find(params[:id])
    @list = List.find(params[:list_id])
    @task.update(status: 'done')
    tmp = 0
    @list.tasks.each do |t|
        if t.status =="done"
            tmp=tmp+1
        end
    end
    if tmp==@list.tasks.size
        @list.update(status: 'done') 
    end
    respond_to do |format|
        format.js { render :status => 200}
    end
  end
def dragdrop
    @list = List.find(params[:list_id])
    @task = Task.find(params[:id])
    newpos = (params[:priority]).to_i-1
    oldpos = @task.priority.to_i-1
    if newpos!=oldpos
    if newpos > oldpos #down
        i=oldpos+1
        while i<=newpos do
            o = @list.tasks[i].priority - 1
            @list.tasks[i].update(priority: o)
            i+=1
        end
    else #up
        i=oldpos
        while i<(newpos+1) do
            #unless  @list.tasks[i].nil?
                o = @list.tasks[i].priority + 1
                @list.tasks[i].update(priority: o)
            #end
            i-=1
        end
    end
    end
   @task.update(priority: params[:priority])
   render nothing: true
end
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to @task, notice: 'Task was successfully updated.' }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end
def rename
    @task = Task.find(params[:id])
    @task.update(name: params[:new_name])
    render nothing: true
end
  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.js
      format.html { redirect_to tasks_url, notice: 'Task was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
        @user = User.find(params[:user_id])
        @list = List.find(params[:list_id])
        @task = Task.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.require(:task).permit(:name, :status, :priority)
    end
end
