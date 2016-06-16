class Subscription < ActiveRecord::Base
  belongs_to :event
  belongs_to :user

  validates :event, presence: true
  validates :user_name, presence: true
  validates :user_email, presence: true, format: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/, unless: 'user.present?'
  validates :user, uniqueness: {scope: :event_id}, if: 'user.present?'
  validates :user_email, uniqueness: {scope: :event_id}, unless: 'user.present?'
  validate :email_taken, unless: 'user.present?'

  def user_name
    if user.present?
      user.name
    else
      super
    end
  end

  def user_email
    if user.present?
      user.email
    else
      super
    end
  end

  def email_taken
    if User.where(email: user_email).exists?
      errors.add(:base, I18n.t('controllers.subscription.email_error'))
    end
  end

end
