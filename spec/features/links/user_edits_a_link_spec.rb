require "rails_helper"

RSpec.feature "User edits a link" do
  context "As an authenticated user with links" do
    let!(:user)  { create(:user) }
    let!(:links) { create_list(:link, 5, user: user) }

    before do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      visit links_path
    end

    describe "on the links page" do
      it "each link should have an Edit button" do
        within "section.lockbox" do
          expect(page).to have_selector("input[value=Edit]", count: user.links.count)
        end
      end

      describe "and when I click an Edit button" do
        it "I should be on the edit link page" do
          within "article#link#{user.links.first.id}" do
            click_on "Edit"
            expect(current_path).to eq edit_link_path(user.links.first)
          end
        end

        describe "and if I submit new information on the form" do
          before(:each) do
            within "article#link#{user.links.first.id}" do
              click_on "Edit"
            end
            fill_in "link_title", with: "New Title"
            fill_in "link_url", with: "http://turing.io/new"
            click_on "Update"
          end

          it "I should be back on the index and see a confirmation" do
            expect(page).to have_content "Link updated!"
            expect(current_path).to eq links_path
          end

          it "and the link's information should be updated" do
            user.links.reload
            expect(user.links.first.title).to eq "New Title"
            expect(user.links.first.url).to eq "http://turing.io/new"
            expect(page).to have_content "New Title"
            expect(page).to have_content "http://turing.io/new"
          end
        end
      end

      context "Sad paths", js: true do
        before(:each) do
          within "article#link#{user.links.first.id}" do
            click_on "Edit"
          end
        end

        describe "if I leave the url blank" do
          it "I get an error on the same page" do
            fill_in "link_title", with: "New Title"
            fill_in "link_url", with: ""
            click_on "Update"
            
            message = page.find("#link_url").native.attribute("validationMessage")
            expect(message).to eq "Please fill out this field."
            expect(current_path).to eq edit_link_path(user.links.first)
          end
        end

        describe "or the title blank on the same page" do
          it "I get an error" do
            fill_in "link_url", with: "http://turing.io/new"
            fill_in "link_title", with: ""
            click_on "Update"
            
            message = page.find("#link_title").native.attribute("validationMessage")
            expect(message).to eq "Please fill out this field."
            expect(current_path).to eq edit_link_path(user.links.first)
          end
        end

        describe "and if I provide a bad url on the same page" do
          it "I get an error" do
            fill_in "link_title", with: "New Title"
            fill_in "link_url", with: "turing.io/new"
            click_on "Update"
            
            message = page.find("#link_url").native.attribute("validationMessage")
            expect(message).to eq "Please enter a URL."
            expect(current_path).to eq edit_link_path(user.links.first)
          end
        end
      end
    end
  end
end

