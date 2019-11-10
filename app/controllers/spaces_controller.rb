class SpacesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user_space, only: [:edit, :update, :destroy, :show]

  def index
    @user_spaces = current_user.spaces
  end

  def show
  end

  def new
    @space = Space.new
    set_space_properties
  end

  def edit
    set_space_properties
  end

  def create
    @space = current_user.spaces.create(space_params)
    respond_to do |format|
      if @space.save
        format.html { redirect_to @space, notice: "Space was successfully created." }
      else
        set_space_properties
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @space.update(space_params)
        format.html { redirect_to @space, notice: "Space was successfully updated." }
      else
        set_space_properties
        format.html { render :edit }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @space.campaigns.count == 0 
        @space.destroy
        format.html { redirect_to spaces_url, notice: "Space was removed." }
      else
        format.html { redirect_to @space, alert: "Space has campaigns. Can't remove." }
      end
    end
  end

  private

    def space_params
      params.require(:space).permit(
        :title, 
        :description, 
        :address, 
        :post_code,
        :contact_info, 
        :price, 
        :space_type, 
        :size, 
        :image, 
        :is_active,
        product_ids: []
      )
    end

    def set_user_space
      @space = current_user.spaces.find_by_id(params[:id])
      if @space == nil
        redirect_to space_path
      end
    end

    def set_space_properties 
      @products = Product.all
      @spaces_types = Space.space_types.keys
      @sizes = Space.sizes.keys
    end
end