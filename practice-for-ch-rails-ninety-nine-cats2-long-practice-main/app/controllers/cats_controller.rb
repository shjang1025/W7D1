class CatsController < ApplicationController
  before_action :require_logged_in, only: [:new, :create]
  before_action :authorize_cat_owner, only: [:edit, :update]

  def index
    @cats = Cat.all
    render :index
  end

  def show
    @cat = Cat.find(params[:id])
    render :show
  end

  def new
    @cat = Cat.new
    render :new
  end

  def create
    @cat = Cat.new(cat_params)
    @cat.owner_id = current_user.id
    if @cat.save
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :new
    end
  end

  def edit
    @cat = Cat.find_by(owner_id: current_user.id)
    render :edit
  end

  def update
    @cat = Cat.find_by(owner_id: current_user.id)
    if @cat.update(cat_params)
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :edit
    end
  end

  private

  def cat_params
    params.require(:cat).permit(:birth_date, :color, :description, :name, :sex)
  end

  def authorize_cat_owner
    @cat = current_user.cats.find(params[:id])
    unless @cat
      flash[:alert] = "You are not authorized to edit this cat."
      redirect_to cats_url
    end
  end

end