require "rails_helper"

RSpec.feature "Show Unread button" do
  context "As an authenticated user on the index page" do
    let(:user) { create(:user) }

    before do
      create_list(:link, 5, user: user)
      user.links.last.update(read: true)
      user.links.first.update(read: true)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      visit links_path
    end

    describe "when I click the Show Unread button", js: true do
      it "only unread links are shown" do
        click_on "Show Unread"
				
        wait_for_ajax
				user.links.all.find_all { |link| link.read }.each do |link|
          expect(page).to_not have_content link.title
          expect(page).to_not have_link link.url
        end
      end
    end
  end
end

