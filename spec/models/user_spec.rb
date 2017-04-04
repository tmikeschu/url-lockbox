require "rails_helper"

RSpec.describe User do
  describe "Validations" do
    it { should validate_uniqueness_of(:email) }
    it { should validate_presence_of(:password) }
  end

  describe "Associations" do
    it { should have_many(:links) }
  end
end
