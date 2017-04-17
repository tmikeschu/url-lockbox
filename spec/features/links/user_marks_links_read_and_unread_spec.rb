require "rails_helper"

RSpec.feature "Marking links read and unread" do
  context "As an authenticated user on the index page", js: true do
    let(:user) { create(:user) }

    before do
      create_list(:link, 5, user: user)
      user.links.last.update(read: true)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      visit links_path
    end

    describe "Next to my unread links" do
      it "I should see a button to Mark as Read" do
        user.links.where(read: false).ids.each do |id|
          within "#link#{id}" do
            expect(page).to have_button "Mark as Read"
          end
        end
      end
    end

    describe "If I click Mark as Read" do
      it "the card says Read? true" do
        within "#link#{user.links.first.id}" do
          expect(page).to have_content "Read? false"
          expect(user.links.first.read).to be false

          click_on "Mark as Read"

          expect(page).to have_content "Read? true"
          expect(user.links.first.read).to be true
        end
      end

      it "and it has a CSS class of 'read'" do
        within "#link#{user.links.first.id}" do
          click_on "Mark as Read"
        end

        card = page.find("#link#{user.links.first.id}")
        expect(card[:class]).to include "read"
      end
    end

    describe "Next to my read links" do
      it "I should see a button to Mark as Unread" do
        user.links.where(read: true).ids.each do |id|
          within "#link#{id}" do
            expect(page).to have_button "Mark as Unread"
          end
        end
      end
    end

    describe "If I click Mark as Unread" do
      it "the card says Read? false" do
        within "#link#{user.links.last.id}" do
          expect(page).to have_content "Read? true"
          expect(user.links.last.read).to be true

          click_on "Mark as Unread"

          expect(page).to have_content "Read? false"
          expect(user.links.last.read).to be false
        end
      end
    
      it "and it does not have a CSS class of 'read'" do
        within "#link#{user.links.last.id}" do
          click_on "Mark as Unread"
        end

        card = page.find("#link#{user.links.last.id}")
        expect(card[:class]).to_not include "read"
      end
    end
  end
end
