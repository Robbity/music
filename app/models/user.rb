class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :validatable

  normalizes :email, with: ->(e) { e.strip.downcase }

  validates :username, presence: true, uniqueness: true
  attr_readonly :username

  has_many :songs, dependent: :destroy
end
