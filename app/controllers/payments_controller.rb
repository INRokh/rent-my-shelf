class PaymentsController < ApplicationController
  before_action :set_user_campaign, only: [:show, :success, :cancel]
  skip_before_action :verify_authenticity_token, only: [:webhook]

  def show
    session = Stripe::Checkout::Session.create(
      payment_method_types: ["card"],
      customer_email: current_user.email,
      line_items: [
        {
          name: @campaign.title,
          amount: @campaign.total_price * 100,  # Cents.
          currency: "aud",
          quantity: 1
        }
      ],
      payment_intent_data: {
        metadata: {
          user_id: current_user.id,
          campaign_id: @campaign.id
        }
      },
      success_url: payment_success_url(@campaign),
      cancel_url: payment_cancel_url(@campaign)
    )
    @session_id = session.id
    @public_key = Rails.application.credentials.dig(:stripe, :public_key)
    @campaign.status_pending_payment!
  end

  def cancel
    respond_to do |format|
      if @campaign.status_pending_payment?
        @campaign.status_new!
        format.html {
          redirect_to @campaign,
          notice: "Payment is cancelled."
        }
      else
        format.html {
          redirect_to @campaign,
          alert: "Campaign has a wrong status: " + @campaign.status
        }
      end
    end
  end

  def webhook
    payment_id = params[:data][:object][:payment_intent]
    payment = Stripe::PaymentIntent.retrieve(payment_id)
    campaign = Campaign.find(payment.metadata.campaign_id)
    campaign_id = payment.metadata.campaign_id

    order = Order.create(
      campaign_id: campaign_id,
      stripe_id: payment_id,
      total: payment.amount / 100
    )

    total_price = 0
    campaign.spaces.each do |space|
      per_space_price =  space.price * (campaign.end_date - campaign.start_date).to_i 
      OrdersSpace.create(
          space_id: space.id,
          order_id: campaign.order.id,
          price: per_space_price
      )
      total_price += per_space_price
    end
    if total_price != campaign.order.total
      raise "Payment price and total price do not match."
    end

    campaign.confirm_payment
      
  end

  def success
    respond_to do |format|
      if @campaign.status_pending_payment?
        @campaign.status_processing_payment!
        format.html {
          redirect_to @campaign,
          notice: "Payment is being confirmed."
        }
      elsif @campaign.status_ready?
        format.html {
          redirect_to @campaign,
          notice: "Payment confirmed."
        }
      else
        format.html {
          redirect_to @campaign,
          alert: "Campaign has a wrong status: " + @campaign.status
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
end