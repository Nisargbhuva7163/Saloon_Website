class ServicesController < ApplicationController
  before_action :set_service, only: [ :show, :edit, :update, :destroy ]
  def new
    @service = Service.new
    @services = Service.all
  end

  def create
    @service = Service.new(service_params)
    if @service.save
      redirect_to new_service_path, notice: "Service was successfully created."
    else
      @services = Service.all
      render :new
    end
  end

  def edit
  end

  def update
    if @service.update(service_params)
      redirect_to new_service_path, notice: "Service was successfully updated."
    else
      render :edit
    end
  end

  def show
  end

  def destroy
    @service.destroy
    redirect_to new_service_path, notice: "Service was successfully destroyed."
  end

  private

  def set_service
    @service = Service.find(params[:id])
  end

  def service_params
    params.require(:service).permit(:name, :price)
  end
end
