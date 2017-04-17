class Link < ActiveRecord::Base
  belongs_to :user

  validates_presence_of(:url, :title)

  scope :by_updated_at, -> { order("links.updated_at DESC") }
end
