require "rails_helper"

RSpec.describe "Links API", type: :request do
  let(:user) { create(:user) }

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  describe "POST /api/v1/links" do
    it "creates a link in the database" do
      links_before = Link.count
      link = { link: { url: "http://turing.io", title: "Turing" } }

      post "/api/v1/links", params: link

      expect(response).to be_success
      expect(Link.count - links_before).to eq 1  
    end

    it "and returns an html partial" do
      link = { link: { url: "http://turing.io", title: "Turing" } }

      post "/api/v1/links", params: link
      expect(response).to be_success

      link_card = response.body
      expect(link_card).to include "<article id=\"link#{Link.last.id}\" class=\"\">"
      expect(link_card).to include "<h4>#{Link.last.title}</h4>"
      expect(link_card).to include Link.last.url
    end

    it "returns JSON errors if data is bad" do
      link = { link: {url: "" } }

      post "/api/v1/links", params: link
      expect(response.status).to eq 400

      errors = JSON.parse(response.body)
      expect(errors).to match ["Url can't be blank", "Title can't be blank"]
    end
  end

  describe "PATCH /api/v1/links/:id" do
    let(:link) { create(:link, user: user) }

    it "updates the read status" do
      status_before = link.read

      link_data = { link: { read: !link.read } }
      patch "/api/v1/links/#{link.id}", params: link_data
      expect(response).to be_success

      link.reload
      expect(link.read).to_not eq status_before
    end

    it "and returns the new object" do
      link_data = { link: { read: !link.read } }
      patch "/api/v1/links/#{link.id}", params: link_data

      response_link = JSON.parse(response.body, symbolize_names: true)
      updated_link = JSON.parse(link.reload.to_json)
      
      expect(updated_link.values).to match_array response_link.values
    end

    it "returns a 500 if data is bad" do
      link_data = { link: { url: "" } }
      patch "/api/v1/links/#{link.id}", params: link_data

      expect(response.status).to eq 500
    end
  end
end
