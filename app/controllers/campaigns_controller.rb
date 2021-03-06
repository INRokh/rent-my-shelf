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
    set_campaign_properties
  end

  def edit
    if @campaign.status_new?
      set_campaign_properties
    else
      respond_to do |format|
        format.html {
          redirect_to @campaign,
          alert: "Campaign can't be edited."
        }
      end
    end
  end

  def create
    @campaign = current_user.campaigns.create(campaign_params)
    respond_to do |format|
      if @campaign.save
        @campaign.status_new!
        format.html {
          redirect_to @campaign,
          notice:"Campaign was successfully created."
        }
      else
        set_campaign_properties
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if !@campaign.status_new?
        format.html format.html {
          redirect_to @campaign,
          alert: "Campaign can't be modified."
        }
      elsif @campaign.update(campaign_params)
        @campaign.spaces.delete_all
        format.html {
          redirect_to @campaign,
          notice: "Campaign was successfully updated."
        }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    respond_to do |format|
      if !@campaign.status_new?
        format.html {
          redirect_to @campaign,
          alert: "Campaign can't be deleted."
        }
      else
        @campaign.destroy
        format.html {
            redirect_to campaigns_url,
            notice: "Campaign was successfully destroyed."
        }
      end
    end
  end

  private

    def campaign_params
      params.require(:campaign).permit(
        :title, 
        :description, 
        :start_date, 
        :end_date, 
        :duration, 
        :size, 
        :status,
        :contact_info, 
        product_ids: []
      )
    end

    def set_user_campaign
      @campaign = current_user.campaigns.find_by_id(params[:id])
      if @campaign == nil
        redirect_to campaign_path
      end
    end

    def set_campaign_properties
      @products = Product.all
      @sizes = Campaign.sizes.keys
    end
end
