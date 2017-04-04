require "rails_helper"

RSpec.feature "User authentication" do
  context "As a user" do
    let!(:user) { create(:user, password: 'password') }
    before do
      visit login_path
    end

    describe "When I log in with correct info" do
      before do
        fill_in "email", with: user.email
        fill_in "password", with: "password"
        click_on "Log In"
      end

      it "I should see a confirmation message" do
        expect(page).to have_content "Login successful!"
      end

      it "and I should be on the links index page" do
        expect(current_path).to eq links_path
      end
    end

    context "When I forget to include", js: true do
      describe "an email address" do
        it "I see an error" do
          fill_in "password", with: "password"
          click_on "Log In"

          message = page.find("#email").native.attribute('validationMessage')

          expect(current_path).to eq login_path
          expect(message).to eq "Please fill out this field."
        end
      end

      describe "a password" do
        it "I see an error" do
          fill_in "email", with: user.email
          click_on "Log In"

          message = page.find("#password").native.attribute('validationMessage')

          expect(current_path).to eq login_path
          expect(message).to eq "Please fill out this field."
        end
      end
    end
    
    context "When I attempt to log in with an invalid" do
      describe "email address" do
        it "I see and error" do
          fill_in "email", with: "wrong@email.com"  
          fill_in "password", with: "password"
          click_on "Log In"

          expect(page).to have_content "Sorry, email not found"
          expect(page).to have_field "email"
          expect(page).to have_field "password"
        end
      end

      describe "password" do
        it "I see and error" do
          fill_in "email", with: user.email
          fill_in "password", with: "wrongPassword"
          click_on "Log In"

          expect(page).to have_content "Sorry, incorrect password"
          expect(page).to have_field "email"
          expect(page).to have_field "password"
        end
      end
    end
  end
end
