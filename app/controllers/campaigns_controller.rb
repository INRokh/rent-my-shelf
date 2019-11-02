class CampaignsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user_campaign, only: [:edit, :update, :destroy, :show]

  def index
    @user_campaigns = current_user.campaigns
  end

  def show
  end

  def new
    @campaign = Campaign.new
    @products = Product.all
    @sizes = Campaign.sizes.keys
  end

  def edit
    @sizes = Campaign.sizes.keys
    @products = Product.all
  end

  def create
    @campaign = current_user.campaigns.create(campaign_params)
   
    respond_to do |format|
      if @campaign.save
        format.html { redirect_to @campaign, notice: 'Campaign was successfully created.' }
        format.json { render :show, status: :created, location: @campaign }
      else
        @sizes = Campaign.sizes.keys
        format.html { render :new }
        format.json { render json: @campaign.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @campaign.update(campaign_params)
        format.html { redirect_to @campaign, notice: 'Campaign was successfully updated.' }
        format.json { render :show, status: :ok, location: @campaign }
      else
        format.html { render :edit }
        format.json { render json: @campaign.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @campaign.destroy
    respond_to do |format|
      format.html { redirect_to campaigns_url, notice: 'Campaign was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def campaign_params
      params.require(:campaign).permit(:title, :description, :start_date, :end_date, :duration, :size, :contact_info, product_ids: [])
    end

    def set_user_campaign
      @campaign = current_user.campaigns.find_by_id(params[:id])
      if @campaign == nil
        redirect_to campaign_path
      end
    end
end
