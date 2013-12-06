class TopicsController < ApplicationController

  before_filter :authenticate
  before_filter :validate_user, :only => [:new, :edit, :create, :update, :destroy]
  before_filter :validate_topic, :only => [:edit, :update, :destroy]
  before_filter :validate_classroom, :only => [:show]

  # GET /topics/1
  # GET /topics/1.json
  def show
    @topic = @classroom.topics.includes(:comments).find_by_id(params[:id])
    @comments = @topic.comments.includes(:user, :merit)
    @comment = Comment.new

    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /topics/new
  # GET /topics/new.json
  def new
    @topic = Topic.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @topic }
    end
  end

  # GET /topics/1/edit
  def edit
    respond_to do |format|
      format.js
    end
  end

  # POST /topics
  # POST /topics.json
  def create
    @topic = @user.topics.build(params[:topic])
     respond_to do |format|
      if @topic.save
        format.js
      else
        format.html { redirect_to classroom_path(@topic.classroom_id), notice: "Topic isn't Created!" }
      end
    end
  end

  # PUT /topics/1
  # PUT /topics/1.json
  def update
    respond_to do |format|
      if @topic.update_attributes(params[:topic])
        format.js 
      else
        format.js { render action: "edit" }
      end
    end
  end

  # DELETE /topics/1
  # DELETE /topics/1.json
  def destroy
    @topic.destroy
    respond_to do |format|
      format.js
    end
  end

  private

  def validate_user
    @user = User.find_by_id(params[:user_id])
  end

  def validate_topic
    @topic = @user.topics.find_by_id(params[:id])
  end

  def validate_classroom
    @classroom = Classroom.find_by_id(params[:classroom_id])
  end
end