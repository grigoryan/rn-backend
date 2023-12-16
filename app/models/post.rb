class Post < ApplicationRecord
  belongs_to :account
  has_many :comments

  has_one_attached :image
end
