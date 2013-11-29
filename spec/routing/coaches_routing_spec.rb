require "spec_helper"

describe CoachesController do
  describe "routing" do

    it "routes to #index" do
      get("/coaches").should route_to("coaches#index")
    end

    it "routes to #new" do
      get("/coaches/new").should route_to("coaches#new")
    end

    it "routes to #show" do
      get("/coaches/1").should route_to("coaches#show", :id => "1")
    end

    it "routes to #edit" do
      get("/coaches/1/edit").should route_to("coaches#edit", :id => "1")
    end

    it "routes to #create" do
      post("/coaches").should route_to("coaches#create")
    end

    it "routes to #update" do
      put("/coaches/1").should route_to("coaches#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/coaches/1").should route_to("coaches#destroy", :id => "1")
    end

  end
end
