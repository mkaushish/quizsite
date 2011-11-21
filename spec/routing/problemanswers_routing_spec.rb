require "spec_helper"

describe ProblemanswersController do
  describe "routing" do

    it "routes to #index" do
      get("/problemanswers").should route_to("problemanswers#index")
    end

    it "routes to #new" do
      get("/problemanswers/new").should route_to("problemanswers#new")
    end

    it "routes to #show" do
      get("/problemanswers/1").should route_to("problemanswers#show", :id => "1")
    end

    it "routes to #edit" do
      get("/problemanswers/1/edit").should route_to("problemanswers#edit", :id => "1")
    end

    it "routes to #create" do
      post("/problemanswers").should route_to("problemanswers#create")
    end

    it "routes to #update" do
      put("/problemanswers/1").should route_to("problemanswers#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/problemanswers/1").should route_to("problemanswers#destroy", :id => "1")
    end

  end
end
