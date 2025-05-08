class RedeemMailer < ApplicationMailer
  default from: "mrnisargbhuvaofficial112003@gmail.com"

  # ← Define this method
  def combo_redeemed(customer, combo)
    @customer = customer
    @combo    = combo
    mail(
      to:      @customer.email,
      subject: "Your Combo Has Been Redeemed!"
    )
  end
end
