class CommentsController < ApplicationController
  before_action :set_comment, only: [:edit, :update, :destroy]
  before_filter :set_request_from
  before_action :authenticate_user!, only: [ :new, :edit, :create, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]

  attr_reader :user_id

  # GET /comments
  # GET /comments.json
  def index
    @comments = Comment.all
  end

  # GET /comments/new
  def new
    @comment = Comment.new
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments
  # POST /comments.json
  def create
    @board = Board.find(params[:board_id])
    @comment = @board.comments.build(comment_params)
    @user = current_user
    @comment.user_id = @user.id

    respond_to do |format|
      if @comment.save
        format.html { redirect_to [@board, @comments], notice: 'Comment was successfully created.' }
        format.json { render :index, status: :created, location: [@board, @comment] }
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        @board = Board.find_by_id(@comment.board_id)
        format.html { redirect_to [@board, @comments], notice: 'Comment was successfully updated.' }
        format.json { render :index, status: :ok, location: [@board, @comment] }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @board = Board.find_by_id(@comment.board_id)
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to [@board, @comments], notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:text,:board_id,:user_id)
    end

    def correct_user
      user_id = Comment.find(params[:id]).user_id
      @user = User.find(user_id)
      redirect_to(root_path) unless current_user == @user
    end
end
