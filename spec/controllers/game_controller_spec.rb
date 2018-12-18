require 'rails_helper'

RSpec.describe GameController, type: :controller do

  describe "GET #start_game," do
    it "returns http success" do
      get :start_game
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #end_game" do
    it "returns http success" do
      get :end_game
      expect(response).to have_http_status(:success)
    end
  end

end
