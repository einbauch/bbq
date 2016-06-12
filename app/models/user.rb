class User < ActiveRecord::Base
  has_many :events
  
  validates :name, presence: true, length: {maximum: 35}
  validates :email, presence: true, length: {maximum: 225}
  validates :email, uniqueness: true
  validates :email, format: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
end
