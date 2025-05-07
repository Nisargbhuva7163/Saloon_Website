class CombosController < ApplicationController
  before_action :set_combo, only: [ :show, :edit, :update, :destroy ]

  def new
    @combo = Combo.new
    @services = Service.all
    @combos = Combo.all
  end

  def create
    @combo = Combo.new(combo_params)
    if @combo.save
      @combos = Combo.includes(:service).order(created_at: :desc)
      redirect_to new_combo_path, notice: "Combo was successfully created."
    else
      @combos = Combo.all
      render :new
    end
  end

  def edit
    @services = Service.all
  end

  def update
    if @combo.update(combo_params)
      redirect_to new_combo_path, notice: "Combo was successfully updated."
    else
      @combos = Combo.all
      render :edit
    end
  end

  def show
  end

  def destroy
    @combo.destroy
    redirect_to new_combo_path, notice: "Combo was successfully destroyed."
  end

  private

  def set_combo
    @combo = Combo.find(params[:id])
  end

  def combo_params
    params.require(:combo).permit(:service_id, :quantity, :discount)
  end
end
