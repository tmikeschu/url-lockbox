require "rails_helper"

RSpec.feature "User views links" do
  context "As an authenticated user with links" do
    let!(:user)  { create(:user) }
    let!(:other_user)  { create(:user) }
    let!(:links) { create_list(:link, 5, user: user) }

    before do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      create(:link, title: "Not Mine", user: other_user)
      visit links_path
    end

    describe "on the links page" do
      it "I should see the links I've added" do
        expect(Link.count).to eq 6

        within "section.lockbox" do
          expect(page).to have_selector("article", count: user.links.count)
        end
      end

      it "and no links that aren't mine" do
        within "section.lockbox" do
          expect(page).to_not have_content "Not Mine"
        end
      end
    end

    describe "and as a different authenticated user" do
      before do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(other_user)
        visit links_path
      end

      it "I don't see another user's links either" do
        within "section.lockbox" do
          expect(page).to_not have_selector("article", count: user.links.count)
          expect(page).to have_selector("article", count: other_user.links.count)
        end
      end
    end
  end
end
