class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :validatable

  normalizes :email, with: ->(e) { e.strip.downcase }

  validates :username, presence: true, uniqueness: true
  has_many :songs, dependent: :destroy
  has_many :ratings, dependent: :destroy

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:email)

    if login
      where(conditions).where("lower(email) = :value OR lower(username) = :value", value: login.downcase).first
    else
      where(conditions).first
    end
  end
end
