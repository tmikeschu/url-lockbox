require "rails_helper"

RSpec.feature "User logs out" do
  context "As a logged in user" do
    let!(:user) { create(:user) }

    before(:each) do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      visit links_path
    end

    describe "on the links page" do

      it "I should not see a log in link" do
        expect(current_path).to eq links_path
        expect(page).to_not have_link "Sign In", href: login_path
      end

      it "and I should see a link to log out" do
        expect(page).to have_link "Sign Out", href: logout_path
      end
    end

    describe "When I click Sign Out" do
      it "I am redirected to the login page" do
        click_on "Sign Out"

        expect(current_path).to eq login_path
      end
    end
  end
end
