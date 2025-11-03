class Post < ApplicationRecord
  belongs_to :user

  validates :title, presence: true, length: { maximum: 120 }
  validates :body,  presence: true
end
