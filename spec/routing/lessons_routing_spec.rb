require "spec_helper"

describe LessonsController do
  describe "routing" do

    it "routes to #index" do
      get("/lessons").should route_to("lessons#index")
    end

    it "routes to #new" do
      get("/lessons/new").should route_to("lessons#new")
    end

    it "routes to #show" do
      get("/lessons/1").should route_to("lessons#show", :id => "1")
    end

    it "routes to #edit" do
      get("/lessons/1/edit").should route_to("lessons#edit", :id => "1")
    end

    it "routes to #create" do
      post("/lessons").should route_to("lessons#create")
    end

    it "routes to #update" do
      put("/lessons/1").should route_to("lessons#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/lessons/1").should route_to("lessons#destroy", :id => "1")
    end

  end
end
