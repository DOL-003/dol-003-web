# frozen_string_literal: true

class Authentication::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    @title = 'Modder registration'
    @allow_register = flag_enabled? :open_registration
    if params[:invitation_token].present?
      invitation = UserInvitation.find_by(claim_token: params[:invitation_token])
      if invitation.present? && invitation.status == UserInvitation::STATUS_UNCLAIMED
        @allow_register = true
      end
    end

    super
  end

  # POST /resource
  def create
    @title = 'Modder registration'
    @allow_register = flag_enabled? :open_registration
    invitation = nil
    if params[:invitation_token].present?
      invitation = UserInvitation.find_by(claim_token: params[:invitation_token])
      if invitation.present? && invitation.status == UserInvitation::STATUS_UNCLAIMED
        @allow_register = true
      end
    end

    if !@allow_register
      flash[:error] = 'Modder registration is invite-only. Sign up using the link in your invitation email.'
      return redirect_to root_path
    end

    super

    if resource.persisted? && invitation.present?
      invitation.status = UserInvitation::STATUS_CLAIMED
      invitation.invitee_user = resource
      invitation.save
    end
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
  def destroy
    if !current_user.valid_password?(params[:user][:password])
      flash[:alert] = 'Password was incorrect.'
      return render :edit
    end

    super
  end

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

  def after_update_path_for(resource)
    edit_user_registration_path
  end
end
