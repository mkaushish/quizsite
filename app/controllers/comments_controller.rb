class CommentsController < ApplicationController

  before_filter :authenticate
  before_filter :validate_user, :only => [:create, :destroy]
  before_filter :validate_comment, :only => [:destroy]

  # GET /comments/1/edit
  def edit
    @comment = Comment.find(params[:id])
  end

  # POST /comments
  # POST /comments.json
  def create
    @comment = @user.comments.create(params[:comment])
    respond_to do |format|
      # if @comment.save
        format.js
        format.html { redirect_to classroom_path(@comment.classroom_id), notice: "Comment Created!" }
      # else
      #   if @comment.classroom_id.blank? 
      #     format.html { redirect_to root_path, notice: "Comment not created!" }
      #   elsif @comment.answer_id.blank?
      #     format.html { redirect_to classroom_path(@comment.classroom_id), notice: "Comment not created!" }
      #   end
      # end
    end
  end

  # PUT /comments/1
  # PUT /comments/1.json
  def update
    @comment = Comment.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
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