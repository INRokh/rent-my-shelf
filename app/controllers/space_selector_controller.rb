class SpaceSelectorController < ApplicationController
    before_action :authenticate_user!
    before_action :set_user_campaign

    def campaign_info

    end

    def index
        @spaces = Space.suitable_for_campaign(
            @campaign.size, @campaign.product_ids)
    end

    def add

    end

    def destroy

    end

    def search

    end

private

    def set_user_campaign
      @campaign = current_user.campaigns.find_by_id(params[:id])
      if @campaign == nil
        redirect_to campaign_path
      end
    end
end