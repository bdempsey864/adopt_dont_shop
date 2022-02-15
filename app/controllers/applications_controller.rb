class ApplicationsController < ApplicationController
  def show
    @application = Application.find(params[:id])
    @pets = Pet.joins(:pet_applications).where(pet_applications: {application_id: @application.id}).pluck(:name)
    @pet = Pet.find_by(name: params[:search_name])
    
  end

  def new
  end

  def create
    application = Application.new(application_params)
    if application.save
      redirect_to "/applications/#{application.id}"
    else
      redirect_to "/applications/new"
      flash[:alert] = "Error: #{error_message(application.errors)}"
    end
  end

    private
    def application_params
      params.permit(:name, :street_address, :city, :state, :zip_code, :description, :status)      
    end

end

