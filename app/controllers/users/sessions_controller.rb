# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  skip_before_action :verify_authenticity_token, only: [:send_otp, :verify_otp, :resend_otp]

  def send_otp
    user = User.find_by(phone_number: params[:phone_number])

    if user.present?
      phone_number = formatted_phone_number(user.phone_number)
      if SmsService.send_otp(phone_number)
        render json: { success: true, phone_number: phone_number }, status: :ok
      else
        render json: { success: false, error: "❌ Failed to send OTP. Please try again." }, status: :unprocessable_entity
      end
    else
      render json: { success: false, error: "❌ Phone number not found." }, status: :not_found
    end
  end

  def verify_otp
    user = User.find_by(phone_number: params[:phone_number])

    if user.present?
      phone_number = formatted_phone_number(user.phone_number)

      # Call the Twilio OTP verification method
      if SmsService.verify_otp(phone_number, params[:otp_code])
        sign_in(user)
        render json: {
          success: true,
          redirect_path: root_path # Redirect to the user's profile page
        }, status: :ok
      else
        render json: { success: false, error: "❌ Invalid OTP or OTP expired." }, status: :unprocessable_entity
      end
    else
      render json: { success: false, error: "❌ Phone number not found." }, status: :not_found
    end
  end

  def resend_otp
    user = User.find_by(phone_number: params[:phone_number])

    if user.present?
      phone_number = formatted_phone_number(user.phone_number)
      if SmsService.send_otp(phone_number)
        render json: { success: true, message: "✅ OTP resent successfully." }, status: :ok
      else
        render json: { success: false, error: "❌ Failed to resend OTP." }, status: :unprocessable_entity
      end
    else
      render json: { success: false, error: "❌ Phone number not found." }, status: :not_found
    end
  end

  private

  def formatted_phone_number(phone_number)
    phone_number.start_with?("+91") ? phone_number : "+91#{phone_number}"
  end
end
