require "spec_helper"

describe BuildsController do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/builds").to route_to("builds#index")
    end

    it "routes to #new" do
      expect(:get => "/builds/new").to route_to("builds#new")
    end

    it "routes to #show" do
      expect(:get => "/builds/1").to route_to("builds#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/builds/1/edit").to route_to("builds#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/builds").to route_to("builds#create")
    end

    it "routes to #update" do
      expect(:put => "/builds/1").to route_to("builds#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/builds/1").to route_to("builds#destroy", :id => "1")
    end

  end
end
