class SpaceSelectorController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user_campaign

  def index
    if params[:post_code] && !params[:post_code].empty?
      @post_code = params[:post_code]
      @spaces = Space.suitable_for_campaign_in_area(
        @campaign.size, @campaign.product_ids, 
        @campaign.start_date, @campaign.end_date,
        @post_code
      )
    else 
      @spaces = Space.suitable_for_campaign(
        @campaign.size, @campaign.product_ids, 
        @campaign.start_date, @campaign.end_date
      )
      @post_code = ""
    end
  end

  def link
    @spaces = Space.suitable_for_campaign(
      @campaign.size, @campaign.product_ids, 
      @campaign.start_date, @campaign.end_date
    )
    respond_to do |format|
      space_id = get_space_id.to_i
      space = @spaces.find { |s| s.id == space_id }
      if space == nil
        format.html {
          redirect_to space_selector_url(post_code: params[:post_code]),
          alert: "Space is not found."
        }
      elsif @campaign.spaces.find { |s| s.id == space_id }
        format.html {
          redirect_to space_selector_url(post_code: params[:post_code]),
          alert: "Space is already linked."
        }
      elsif @campaign.status_new?
        format.html {
          redirect_to space_selector_url(post_code: params[:post_code]),
          alert: "Space must be in status New."
        }
      else
        @campaign.spaces << space
        format.html {
          redirect_to space_selector_url(post_code: params[:post_code]),
          notice: "Space is added."
        }
      end
    end
  end

  def unlink
    respond_to do |format|
      space_id = get_space_id.to_i
      space = @campaign.spaces.find_by_id(space_id)
      if space == nil
        format.html {
          redirect_to space_selector_url(post_code: params[:post_code]),
          alert: "Space is not found."
        }
      elsif @campaign.status_new?
        format.html {
          redirect_to space_selector_url(post_code: params[:post_code]),
          alert: "Space must be in status New."
        }
      else
        @campaign.spaces.delete(space)
        format.html {
          redirect_to space_selector_url(post_code: params[:post_code]),
          notice: "Space is removed."
        }
      end
    end
  end

  private

  def set_user_campaign
    @campaign = current_user.campaigns.find_by_id(params[:id])
    if @campaign == nil
      redirect_to campaign_path
    end
  end

  def get_space_id
    params.require(:space_id)
  end
end