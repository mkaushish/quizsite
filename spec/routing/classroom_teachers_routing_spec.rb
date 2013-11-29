require "spec_helper"

describe ClassroomTeachersController do
  describe "routing" do

    it "routes to #index" do
      get("/classroom_teachers").should route_to("classroom_teachers#index")
    end

    it "routes to #new" do
      get("/classroom_teachers/new").should route_to("classroom_teachers#new")
    end

    it "routes to #show" do
      get("/classroom_teachers/1").should route_to("classroom_teachers#show", :id => "1")
    end

    it "routes to #edit" do
      get("/classroom_teachers/1/edit").should route_to("classroom_teachers#edit", :id => "1")
    end

    it "routes to #create" do
      post("/classroom_teachers").should route_to("classroom_teachers#create")
    end

    it "routes to #update" do
      put("/classroom_teachers/1").should route_to("classroom_teachers#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/classroom_teachers/1").should route_to("classroom_teachers#destroy", :id => "1")
    end

  end
end
