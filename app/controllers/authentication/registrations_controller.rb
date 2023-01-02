# frozen_string_literal: true

class Authentication::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    @allow_register = false
    if params[:invitation_token].present?
      invitation = ModderInvitation.find_by(claim_token: params[:invitation_token])
      if (invitation.present? && invitation.status == ModderInvitation::STATUS_UNCLAIMED)
        @allow_register = true
      end
    end
    @allow_register = true

    super
  end

  # POST /resource
  def create
    allow_register = true
    if params[:invitation_token].present?
      invitation = ModderInvitation.find_by(claim_token: params[:invitation_token])
      if (invitation.present? && invitation.status == ModderInvitation::STATUS_UNCLAIMED)
        allow_register = true
      end
    end

    if !allow_register
      flash[:error] = 'Modder registration is invite-only. Sign up using the link in your invitation email.'
      return redirect_to root_path
    end

    super
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
