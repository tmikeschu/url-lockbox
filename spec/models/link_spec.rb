require "rails_helper"

RSpec.describe Link do
  describe "Associations" do
    it { should belong_to(:user) }
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
end
