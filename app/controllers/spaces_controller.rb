class SpacesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_space, only: [:show]
  before_action :set_user_space, only: [:edit, :update, :destroy]

  def index
    @spaces = Space.all
  end

  def show
  end

  def new
    @space = Space.new
    @spaces_types = Space.space_types.keys
    @sizes = Space.sizes.keys
  end

  def edit
    @spaces_types = Space.space_types.keys
    @sizes = Space.sizes.keys
  end

  def create
    @space = current_user.spaces.create(space_params)
    respond_to do |format|
      if @space.save
        format.html { redirect_to @space, notice: 'Space was successfully created.' }
        format.json { render :show, status: :created, location: @space }
      else
        @sizes = Space.sizes.keys
        format.html { render :new }
        format.json { render json: @space.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @space.update(space_params)
        format.html { redirect_to @space, notice: 'Space was successfully updated.' }
        format.json { render :show, status: :ok, location: @space }
      else
        format.html { render :edit }
        format.json { render json: @space.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @space.destroy
    respond_to do |format|
      format.html { redirect_to spaces_url, notice: 'Space was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def set_space
      @space = Space.find(params[:id])
    end

    def space_params
      params.require(:space).permit(:title, :description, :address, :post_code,
      :contact_info, :price, :space_type, :size)
    end

    def set_user_space
      @space = current_user.spaces.find_by_id(params[:id])
      if @space == nil
        redirect_to space_path
      end
    end
end
