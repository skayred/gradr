class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :courses

  validates :key, uniqueness: true
  before_save :generate_keys

  def self.generate_random_string(length)
    o = [('a'..'z'), ('A'..'Z')].map(&:to_a).flatten
    string = (0...length).map { o[rand(o.length)] }.join
  end

  def generate_keys
    if self.key.blank? && self.secret.blank?
      self.key = User.generate_random_string 8
      self.secret = User.generate_random_string 50
    end
  end
end
