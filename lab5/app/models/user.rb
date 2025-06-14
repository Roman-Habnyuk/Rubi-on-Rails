class User < ApplicationRecord
  has_many :posts
  has_many :comments

  validates :name, presence: true, length: { minimum: 2 }
  validates :email, presence: true, uniqueness: true
end
