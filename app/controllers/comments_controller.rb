class CommentsController < ApplicationController

    before_filter :authenticate
    before_filter :validate_user, :only => [:new, :edit, :create, :update, :destroy]
    before_filter :validate_comment, :only => [:edit, :update, :destroy]

    def new
        @comment = Comment.new
        if defined? params[:classroom_id]
            @comment.classroom_id = params[:classroom_id]
        elsif defined? params[:answer_id]
            @comment.answer_id = params[:answer_id]
        end

        @reply_comment_id = params[:reply_comment_id] if defined? params[:reply_comment_id]
        respond_to do |format|
            format.js
        end
    end 

    # GET /comments/1/edit
    def edit
        respond_to do |format|
            format.js
        end
    end

    # POST /comments
    # POST /comments.json
    def create
        @comment = @user.comments.build(params[:comment])
        respond_to do |format|
            if @comment.save
                @parent_comment = Comment.find_by_id(@comment.reply_comment_id) unless @comment.reply_comment_id.blank?
                format.js
            else
                format.html { redirect_to classroom_path(@comment.classroom_id), notice: "Comment isn't Created!" }
            end
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