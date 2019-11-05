Learn more or give us feedback
class PaymentsController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:webhook]

    def success

    end

    def webhook
        payment_id = params[:data][:object][:payment_intent]
        payment = Stripe::PaymentIntent.retrieve(payment_id)

        Purchase.create(
            user_id: payment.metadata.user_id,
            campaign_id: payment.metadata.campaign_id,
            order_id: payment_id
        )
        status 200
    end
end