require "rails_helper"

RSpec.feature "Type to filter" do
  context "As an authenticated user on the index page" do
    let(:user) { create(:user) }

    before do
      create_list(:link, 5, user: user)
      user.links.last.update(read: true)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      visit links_path
    end

    describe "when I type in the search field", js: true do
      it "the amount of displayed cards decreases to only matching results" do
        query = user.links.first.title[0..3]
        fill_in "link-filter", with: query.downcase
				
				page_matches = page.all(".lockbox article", visible: true)
				db_matches = user.links.all.find_all do |link|
					title = link.title.downcase
					url = link.url.downcase
					url.include?(query.downcase) || title.include?(query.downcase)
				end	
				expect(page_matches.count).to eq db_matches.count
      end
    end
  end
end
