class PetApplicationsController < ApplicationController
  def create
    pet_app = PetApplication.create!(pet_id: params["pet_id"], application_id: params["application_id"])
    redirect_to "/applications/#{pet_app.application_id}"
  end
end