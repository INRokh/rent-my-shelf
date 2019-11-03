class SpaceSelectorController < ApplicationController
    before_action :authenticate_user!
    before_action :set_user_campaign

    def campaign_info

    end

    def index
        @spaces = Space.suitable_for_campaign(
            @campaign.size, @campaign.product_ids)
        @linked_spaces = Set.new
        @campaign.spaces.each do |space|
            @linked_spaces << space.id
        end
    end

    def link
        @spaces = Space.suitable_for_campaign(
            @campaign.size, @campaign.product_ids)
        respond_to do |format|
            space_id = get_space_id.to_i
            space = @spaces.find { |s| s.id == space_id }
          if space == nil
              format.html { redirect_to space_selector, alert: 'Space is not found.' }
          elsif @campaign.spaces.find { |s| s.id == space_id }
              format.html { redirect_to space_selector_url, alert: 'Space is already linked.' }
          else
              @campaign.spaces << space
              format.html { redirect_to space_selector_url, notice: 'Space is added.' }
          end
        end
    end

    def unlink
        @spaces = Space.suitable_for_campaign(
            @campaign.size, @campaign.product_ids)
        respond_to do |format|
            space_id = get_space_id.to_i
            space = @campaign.spaces.find_by_id(space_id)
            if space == nil
                format.html { redirect_to space_selector_url, alert: 'Space is not found.' }
            else
                @campaign.spaces.delete(space)
                format.html { redirect_to space_selector_url, notice: 'Space is removed.' }
            end
        end
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

    def get_space_id
        params.require(:space_id)
    end

end