class Campaign < ApplicationRecord
  belongs_to :user
  has_one :order
  has_and_belongs_to_many :spaces
  has_and_belongs_to_many :products
  # validates :title, :size, :start_date, :end_date, :contact_info, presence: true
  # # validates :size, inclusion: { in: @sizes.keys }
 
  enum size: { 
    small: 0, 
    medium: 1, 
    large: 2,
    extra_large: 3 
  }
  enum status: {
    new: 0,
    pending_payment: 1,
    processing_payment: 2,
    ready: 3,
    finished: 4
  }, _prefix: :status

  def total_price
    days = (end_date - start_date).to_i
    return spaces.sum(:price) * days
  end

  def confirm_payment
    if status_processing_payment? || status_pending_payment?
      status_ready!
    else
      raise "Wrong status of campaign: " + status
    end
  end
end
