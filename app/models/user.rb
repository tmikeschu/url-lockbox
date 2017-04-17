class User < ApplicationRecord
  has_secure_password
  validates :email, uniqueness: true

  has_many :links

  def links_by_updated_at
    self.links.by_updated_at
  end
end
