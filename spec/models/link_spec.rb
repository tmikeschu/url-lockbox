require "rails_helper"

RSpec.describe Link do
  describe "Associations" do
    it { should belong_to(:user) }
  end

  describe "Validations" do
    it { should validate_presence_of(:url) }
    it { should validate_presence_of(:title) }
    it { should validate_inclusion_of(:read).in_array([true, false]) }
  end

  context "Defaults" do
    describe "Links" do
      it "are not read by default" do
        link = Link.create(url: "http://turing.io", title: "Turing")
        expect(link.read).to be false
      end

      it "but can be overridden" do
        link = Link.create(url: "http://turing.io", title: "Turing")
        link.update(read: true)
        expect(link.read).to be true
      end
    end
  end

  context "Scopes" do
    describe ".by_updated_at" do
      it "sorts by updated at time, descending" do
        link1 = create(:link)
        sleep(1/10)
        link2 = create(:link)
        sleep(1/10)
        link3 = create(:link)
        
        link2.update(title: "UPDATE")
       
        expect(Link.by_updated_at.pluck(:id)).to match [link2.id, link3.id, link1.id]
      end
    end
  end
end
