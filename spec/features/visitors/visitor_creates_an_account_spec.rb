require 'rails_helper'

RSpec.feature "Visitor creates an account" do
  context "As a visitor" do
    describe 'When I visit the root path' do
      it "I am redirected to the login path" do
        visit root_path
        expect(current_path).to eq login_path
        expect(page).to have_content "Login"
        expect(page).to have_content "Don't have an account? Sign up here."
        expect(page).to have_link "here", href: new_user_path
        expect(page).to have_field "email"
        expect(page).to have_field "password"
        expect(page).to have_button "Log In"
      end
    end

    describe "When I click the link to sign up" do
      it "I am taken to the new user path" do
        visit login_path
        click_on 'here'

        expect(current_path).to eq new_user_path
        expect(page).to have_content "Signup"
        expect(page).to have_content "Already have an account? Log in here."
        expect(page).to have_link "here", href: login_path
        expect(page).to have_field "user_email"
        expect(page).to have_field "user_password"
        expect(page).to have_field "user_password_confirmation"
        expect(page).to have_button "Sign Up"
      end
    end

    describe "When I fill in the sign up form and submit" do
      before do
        visit new_user_path
        fill_in "user_email", with: "test@test.com"
        fill_in "user_password", with: "password"
        fill_in "user_password_confirmation", with: "password"
        click_on "Sign Up"
      end

      it "I am taken to the links index page" do
        expect(current_path).to eq links_path
      end

      it "and I am a user in the database" do
        expect(User.count).to eq 1
        expect(User.first.email).to eq "test@test.com"
      end
    end

    context "Sad paths" do
      let!(:user) { create(:user) }

      before(:each) do
        visit new_user_path
      end

      describe "if I try to use an existing user email" do
        it "I get an error" do
          fill_in "user_email", with: user.email
          fill_in "user_password", with: "password"
          fill_in "user_password_confirmation", with: "password"
          click_on "Sign Up"

          expect(page).to have_content "Email has already been taken"
          expect(page).to have_field "user_email"
          expect(page).to have_field "user_password"
          expect(page).to have_field "user_password_confirmation"
        end
      end

      describe "if I don't include email" do
        it "I get an error", js: true do
          fill_in "user_password", with: "password"
          fill_in "user_password_confirmation", with: "password"
          click_on "Sign Up"

          expect(current_path).to eq new_user_path
          expect(page).to have_css("#user_email[required]")
        end
      end

      describe "if I don't include a password" do
        it "I get an error", js: true do
          fill_in "user_email", with: user.email
          fill_in "user_password_confirmation", with: "password"
          click_on "Sign Up"

          expect(current_path).to eq new_user_path
          expect(page).to have_css("#user_password[required]")
        end
      end

      describe "if I don't include a password confirmation" do
        it "I get an error", js: true do
          fill_in "user_email", with: user.email
          fill_in "user_password", with: "password"
          click_on "Sign Up"

          expect(current_path).to eq new_user_path
          expect(page).to have_css("#user_password_confirmation[required]")
        end
      end

      describe "if my passwords don't match" do
        it "I get an error" do
          fill_in "user_email", with: user.email
          fill_in "user_password", with: "password"
          fill_in "user_password_confirmation", with: "passwrod"
          click_on "Sign Up"

          expect(page).to have_content "Password confirmation doesn't match Password"
          expect(page).to have_field "user_email"
          expect(page).to have_field "user_password"
          expect(page).to have_field "user_password_confirmation"
        end
      end
    end
  end
end
