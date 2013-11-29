require "spec_helper"

describe CustomProblemsController do
  describe "routing" do

    it "routes to #index" do
      get("/custom_problems").should route_to("custom_problems#index")
    end

    it "routes to #new" do
      get("/custom_problems/new").should route_to("custom_problems#new")
    end

    it "routes to #show" do
      get("/custom_problems/1").should route_to("custom_problems#show", :id => "1")
    end

    it "routes to #edit" do
      get("/custom_problems/1/edit").should route_to("custom_problems#edit", :id => "1")
    end

    it "routes to #create" do
      post("/custom_problems").should route_to("custom_problems#create")
    end

    it "routes to #update" do
      put("/custom_problems/1").should route_to("custom_problems#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/custom_problems/1").should route_to("custom_problems#destroy", :id => "1")
    end

  end
end
