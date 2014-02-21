require 'spec_helper'

describe "Scripts" do
  describe "GET /repositories" do
    it "index" do
      get repositories_path
      expect(response.status).to be(200)
    end
  end
end
