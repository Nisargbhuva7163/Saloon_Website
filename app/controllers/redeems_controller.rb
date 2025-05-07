class RedeemsController < ApplicationController
  def index
    @customers = Customer.all
  end

  def select_customer
    if params[:customer_id].present?
      # Store the selected customer's ID in the session
      session[:selected_customer_id] = params[:customer_id]

      # Check if the selected customer has combos
      @customer = Customer.find(session[:selected_customer_id])
      @combos = @customer.combos

      if @combos.any?
        # If customer has combos, redirect to the page to show the combos
        redirect_to check_combos_redeems_path
      else
        # If customer does not have combos, show a message
        redirect_to check_combos_redeems_path
      end
    else
      redirect_to redeems_path, alert: "Please select a customer."
    end
  end

  def redeem_combo
    @customer = Customer.find(session[:selected_customer_id])
    @combo = @customer.combos.find_by(id: params[:combo_id])

    if @combo.present?
      total_redeemed = Redeem.where(customer: @customer, combo: @combo).count
      remaining = @combo.quantity - total_redeemed

      if remaining > 0
        Redeem.create!(customer: @customer, combo: @combo)
        redirect_to check_combos_redeems_path, notice: "Successfully redeemed one combo. Remaining: #{remaining - 1}"
      else
        redirect_to check_combos_redeems_path, alert: "No remaining quantity to redeem."
      end
    else
      redirect_to check_combos_redeems_path, alert: "Combo not found for this customer."
    end
  end

  def check_combos
    @customer = Customer.find(session[:selected_customer_id])
    @combos = @customer.combos
  end
end
