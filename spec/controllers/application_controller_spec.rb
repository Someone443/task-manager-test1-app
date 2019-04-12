require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do

	it "renders the users#show template for root path" do
      expect(get: root_url).to route_to(controller: "users", action: "show")
    end
end