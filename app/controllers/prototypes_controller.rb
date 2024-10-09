class PrototypesController < ApplicationController

  before_action :authenticate_user!, only: [:new, :edit, :create, :update, :destroy] 
  before_action :check_author, only: [:edit, :update, :destroy]  # 投稿者チェックを edit, update, destroy アクションに適用

  def index
    @prototypes = Prototype.all
  end

  def new
    @prototype = Prototype.new
  end
  
  def create
    @prototype = Prototype.new(prototype_params)
    if @prototype.save
      redirect_to root_path, notice: "Prototype was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @prototype = Prototype.find(params[:id])
    if @prototype.destroy
      redirect_to root_path
    end
  end 
  
  def show
    @prototype = Prototype.find_by(id: params[:id])  # 先にプロトタイプを取得
    if @prototype.nil?
      redirect_to root_path, alert: "Prototype not found"
    else
      @comment = Comment.new
      @comments = @prototype.comments.includes(:user)  # コメントを取得
    end
  end
  
 
  def edit
    @prototype = Prototype.find(params[:id])
  end

  def update
    @prototype = Prototype.find(params[:id])
    if @prototype.update(prototype_params)
      redirect_to prototype_path(@prototype), notice: "Prototype was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end
  


  private
  
  def prototype_params
    params.require(:prototype).permit(:catch_copy, :title, :concept, :image).merge(user_id: current_user.id)
  end

  def check_author
    @prototype = Prototype.find(params[:id])
    # 投稿者とログインしているユーザーが異なる場合、トップページにリダイレクト
    if @prototype.user != current_user
      redirect_to root_path
    end
  end
end