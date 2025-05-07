class CustomerCombosController < ApplicationController
  before_action :set_selected_customer, only: [ :assign_combo, :create ]

  def index
    @customers = Customer.all
    @q = Customer.ransack(params[:q])
    @customers = @q.result(distinct: true)
  end

  def select_customer
    if params[:customer_id].present?
      session[:selected_customer_id] = params[:customer_id]
      redirect_to assign_combo_customer_combos_path
    else
      redirect_to customer_combos_path, alert: "Please select at least one customer"
    end
  end

  def assign_combo
    @customer = Customer.find_by(id: session[:selected_customer_id])
    @combos = Combo.all
  end

  def create
    combo_ids = params[:combo_ids]

    if combo_ids.present? && @customer
      combo_ids.each do |combo_id|
        combo = Combo.find_by(id: combo_id)
        if combo
          CustomerCombo.create(customer: @customer, combo: combo)
        end
      end

      session.delete(:selected_customer_id)
      redirect_to customer_combos_path, notice: "Combo assigned to selected customer!"
    else
      redirect_to assign_combo_customer_combos_path, alert: "Combo assignment failed."
    end
  end

  private

  # Optional: If you need to ensure the customer is selected before performing an action
  def set_selected_customer
    customer_id = session[:selected_customer_id]
    @customer = Customer.find_by(id: customer_id)
    redirect_to customer_combos_path, alert: "No customers selected." unless @customer
  end
end
