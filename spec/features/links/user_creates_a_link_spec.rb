require "rails_helper"

RSpec.feature "User creates a link" do
  context "As an authenticated user" do
    let!(:user) { create(:user) }

    before do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      visit links_path
    end

    describe "on the links page" do
      it "I should see a form to create a link" do
        expect(page).to have_content "Add a Link"
        expect(page).to have_field "link_url" 
        expect(page).to have_field "link_title" 
        expect(page).to have_button "Lock It Up"
      end
    end

    describe "when I submit a link" do
      it "a link gets added to the database" do
        expect(Link.count).to eq 0

        fill_in "link_url", with: "http://turing.io"        
        fill_in "link_title", with: "Turing Homepage"        
        click_on "Lock It Up"

        expect(Link.count).to eq 1
      end

      it "and I can see that link now in the index" do
        fill_in "link_url", with: "http://turing.io"        
        fill_in "link_title", with: "Turing Homepage"        
        click_on "Lock It Up"

        link = Link.last

        expect(current_path).to eq links_path

        within "#link#{link.id}" do
          expect(page).to have_link link.url, href: link.url
          expect(page).to have_content link.title
          expect(page).to have_content "Read? false"
          expect(page).to have_button "Mark as Read"
        end
      end
    end

    context "when I submit an invalid", js: true do
      describe "url" do
        it "the link is not added, I get an error, and I am on the same page" do
          expect(Link.count).to eq 0

          fill_in "link_url", with: "turing.io"        
          fill_in "link_title", with: "Turing Homepage"        
          click_on "Lock It Up"

          message = page.find("#link_url").native.attribute('validationMessage')

          expect(Link.count).to eq 0
          expect(message).to eq "Please enter a URL."
          expect(current_path).to eq links_path
        end
      end
    end

    context "when I forget", js: true do
      describe "the url" do
        it "I see an error" do
          fill_in "link_title", with: "Turing Homepage"        
          click_on "Lock It Up"

          message = page.find("#link_url").native.attribute('validationMessage')
          expect(message).to eq "Please fill out this field."
        end
      end

      describe "or the title" do
        it "I see an error" do
          fill_in "link_url", with: "http://turing.io"        
          click_on "Lock It Up"

          message = page.find("#link_title").native.attribute('validationMessage')
          expect(message).to eq "Please fill out this field."
        end
      end
    end
  end 
end
