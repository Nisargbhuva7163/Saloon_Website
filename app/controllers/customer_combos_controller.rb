class CustomerCombosController < ApplicationController
  before_action :set_selected_customer, only: [:assign_combo, :create]

  def index
    @customers = Customer.all
    @q = Customer.ransack(params[:q])
    @customers = @q.result(distinct: true)
  end

  def select_customer
    if params[:customer_id].present?
      redirect_to assign_combo_customer_combos_path(customer_id: params[:customer_id])
    else
      redirect_to customer_combos_path, alert: "Please select at least one customer"
    end
  end

  def assign_combo
    @combos = Combo.all
  end

  def create
    combo_ids = params[:combo_ids]

    if combo_ids.present? && @customer
      combo_ids.each do |combo_id|
        combo = Combo.find_by(id: combo_id)
        CustomerCombo.create(customer: @customer, combo: combo) if combo
      end
      redirect_to customer_combos_path, notice: "Combo assigned to selected customer!"
    else
      redirect_to assign_combo_customer_combos_path(customer_id: @customer.id), alert: "Combo assignment failed."
    end
  end

  private

  def set_selected_customer
    @customer = Customer.find_by(id: params[:customer_id])
    redirect_to customer_combos_path, alert: "No customers selected." unless @customer
  end
end
