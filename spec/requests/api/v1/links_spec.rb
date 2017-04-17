require "rails_helper"

RSpec.describe "Links API", type: :request do
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
      expect(link_card).to include "<article id=\"link#{Link.last.id}\">"
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
end
