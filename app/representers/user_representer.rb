require 'roar/json'

module UserRepresenter
  include Roar::JSON

  property :id
  property :first_name
  property :last_name
  property :name, as: :artist_name
  property :email
  property :errors, if: lambda { |args| errors.messages.length > 0 }
  property :user_status, as: :status
  property :phone
  property :description
  property :trial_began
  property :trial_ended
  property :trial_user
  property :expires_on
  property :days_left
  property :customer_id, as: :stripe_customer_id
  property :stripe_subscription_id
  property :stripe_active_until
  property :ua, if: lambda { |args| is_uber_amdin? }

  private

  def customer_id
    stripe_customer_id ? stripe_customer_id : "Not Created"
  end

  def expires_on
    return nil unless is_trial_user?
    began = trial_began ? trial_began : Time.now
    began + (promo_code && promo_code.duration ? promo_code.duration.days : 30.days)
  end

  def days_left
    return 0 unless is_trial_user?
    days = (expires_on - Time.now).to_i / 1.day
    days = 0 if days < 0
    days
  end

  def name
    artist_name ? artist_name : 'No Artist Name'
  end

  # def user_status
  #   (!is_trial_user? || (is_trial_user? && days_left > 0)) ? 'active' : 'expired'
  # end

  def user_status
      ((is_trial_user? && days_left == 0) || (is_trial_user? && customer_id != "Not Created")) ? "expired" : "active"
  end

  def trial_user
    is_trial_user?
  end

  def ua
    is_uber_amdin?
  end

end