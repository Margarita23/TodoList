class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!
  # GET /users
  # GET /users.json
  def index
    @users = User.all
    redirect_to current_user
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @task = Task.new
    @list = List.new
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  def statistics
    @user = User.find(params[:id])
#query 1
    @query_0 = @user.tasks.select(:status).uniq
    sort = []
    @user.lists.each do |i|
        sort.push({"value"=>i.tasks.size, "name"=>i.title})
    end
#query 2
    @sorted = sort.sort_by { |k| k["value"] }.reverse
#query 3
    @sorted_2 = sort.sort_by { |k| k["name"] }
#query 4
    @exp = @user.lists.where(/^N/.match(:title)!=0)
#query 5
     # @exp_lists_a = @user.lists.where('title REGEXP ".+a.+"')
#query 6
      rep_sort = []
      @user.tasks.each do |i|
        rep_sort.push({ "name"=>i.name})
      end
      @rep = rep_sort.sort_by { |k| k["name"] }
      @res = @rep.each_with_object(Hash.new(0)) { |word,counts| counts[word] += 1 }
#query 7
      @pro_garage = @user.lists.find_by(title: 'Garage')
      arr_1 = arr_2 = @pro_garage.tasks.to_ary
      get_arr = []
      
      arr_1.each do |a1|
          counter=0
          t_arr = []
          arr_2.each do |a2|
              unless a1.id==a2.id
                  if a1.name==a2.name && a1.status==a2.status
                      if counter==0
                          counter=2
                      else counter+=1
                      end
                      t_arr.push(a2.id)
                  end
              end  
          end
          if counter>0
            get_arr.push(Hash["counter"=>counter, "element"=>a1])
              t_arr.each do |el|
                  arr_2.delete_if{|a| a.id==el}
              end    
          end
      end
      @sort_get_arr = get_arr.sort_by{|c| c['counter']}
      
#query 8
      @more_10 = []
      @user.lists.each do |p|
          if p.tasks.where(status: "done").size>10
              @more_10.push(p)
          end
      end
    respond_to do |format|
        format.html    
    end
  end
  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
      
    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params[:user]
    end
end
