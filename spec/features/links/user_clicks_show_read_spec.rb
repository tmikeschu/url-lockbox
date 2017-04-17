require "rails_helper"

RSpec.feature "Show Read button" do
  context "As an authenticated user on the index page" do
    let(:user) { create(:user) }

    before do
      create_list(:link, 5, user: user)
      user.links.last.update(read: true)
      user.links.first.update(read: true)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      visit links_path
    end

    describe "when I click the Show Read button", js: true do
      it "only read links are showed" do
        click_on "Show Read"
				
				page_matches = page.all(".lockbox article", visible: true)
				db_matches = user.links.all.find_all { |link| link.read }	
				expect(page_matches.count).to eq db_matches.count
      end
    end
  end
end
