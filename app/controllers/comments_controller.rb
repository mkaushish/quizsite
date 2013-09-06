class CommentsController < ApplicationController

  before_filter :authenticate
  before_filter :validate_user, :only => [:edit, :create, :update, :destroy]
  before_filter :validate_comment, :only => [:edit, :update, :destroy]

  # GET /comments/1/edit
  def edit
    respond_to do |format|
      format.js
    end
  end

  # POST /comments
  # POST /comments.json
  def create
    @comment = @user.comments.create(params[:comment])
    respond_to do |format|
        format.js
        format.html { redirect_to classroom_path(@comment.classroom_id), notice: "Comment Created!" }
    end
  end

  # PUT /comments/1
  # PUT /comments/1.json
  def update
    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.js 
      else
        format.js { render action: "edit" }
      end
    end
  end

  # DELETE /comments/1
  def destroy
    @comment.destroy
    respond_to do |format|
      format.js
    end
  end

  private

  def validate_user
    @user = User.find_by_id(params[:user_id])
  end

  def validate_comment
    @comment = @user.comments.find(params[:id])
  end
end