class RedeemsController < ApplicationController
  before_action :set_customer, only: [:check_combos, :redeem_combo]

  def index
    @customers = Customer.all
  end

  def select_customer
    if params[:customer_id].present?
      redirect_to check_combos_redeems_path(customer_id: params[:customer_id])
    else
      redirect_to redeems_path, alert: "Please select a customer."
    end
  end

  def check_combos
    # Fetch the CustomerCombos related to the customer
    @customer_combos = CustomerCombo.where(customer_id: @customer.id)

    # Now we are displaying the combos via CustomerCombo relation
    @combos = @customer_combos.map(&:combo)
  end

  def redeem_combo
    # Fetch the combo from the CustomerCombo relationship
    @customer_combo = CustomerCombo.find_by(id: params[:customer_combo_id])
    if @customer_combo.present?
      total_redeemed = @customer_combo.redeems.count
      puts total_redeemed
      remaining = @customer_combo.combo.quantity - total_redeemed

      if remaining > 0
        Redeem.create!(customer_combo: @customer_combo)  # Redeem belongs to CustomerCombo now
        RedeemMailer.combo_redeemed(@customer_combo.customer, @customer_combo.combo).deliver_later
        redirect_to check_combos_redeems_path(customer_id: @customer.id), notice: "Successfully redeemed one combo. Remaining: #{remaining - 1}"
      else
        redirect_to check_combos_redeems_path(customer_id: @customer.id), alert: "No remaining quantity to redeem."
      end
    else
      redirect_to check_combos_redeems_path(customer_id: @customer.id), alert: "Combo not found for this customer."
    end
  end

  private

  def set_customer
    @customer = Customer.find_by(id: params[:customer_id])
    redirect_to redeems_path, alert: "Customer not found." unless @customer
  end
end
