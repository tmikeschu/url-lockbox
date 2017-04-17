require "rails_helper"

RSpec.describe User do
  describe "Validations" do
    it { should validate_uniqueness_of(:email) }
    it { should validate_presence_of(:password) }
  end

  describe "Associations" do
    it { should have_many(:links) }
  end

  describe "Methods" do
    describe "#links_by_updated_at" do
      let(:user) { create(:user) }

      it "returns links sorted descending by updated at" do
        link1 = create(:link, user: user)
        sleep(1/10)
        link2 = create(:link, user: user)
        sleep(1/10)
        link3 = create(:link, user: user)
        
        link2.update(title: "UPDATE")
       
        expect(user.links_by_updated_at.pluck(:id)).to match [link2.id, link3.id, link1.id]
      end
    end
  end
end
