class Comment < ActiveRecord::Base

  belongs_to :commentable, polymorphic: true
  has_many :comments, as: :commentable, dependent: :destroy

  validates :comment, presence: true
  validates :email, presence: true

end
