class ProfilesController < ApplicationController

  before_action :authenticate_user!

  def show
    return redirect_to edit_profile_path if current_modder.blank?
    redirect_to modder_path(current_modder)
  end

  def new
    redirect_to edit_profile_path(new: true)
  end

  def edit
    if params[:new].present?
      authenticate_admin!
      @modder = Modder.new
      @form_submit_path = profiles_path
    elsif params[:id].present?
      authenticate_admin!
      @modder = Modder.find_by(slug: params[:id])
      @form_submit_path = admin_update_profile_path(@modder)
    else
      @modder = current_modder || Modder.new(user: current_user)
      @form_submit_path = profile_path
    end

    @is_admin = current_user.admin?
    @onboarding = !@modder.persisted?
    @title = @onboarding ? 'Create profile' : 'Edit profile'
  end

  def create
    update
  end

  def update
    if params[:id].present?
      authenticate_admin!
      @modder = Modder.find_by(slug: params[:id])
    elsif params.require(:modder).permit(:unclaimed).present?
      authenticate_admin!
      @modder = Modder.new
    else
      @modder = current_modder || Modder.new(user: current_user)
    end

    @onboarding = !@modder.persisted?

    begin
      @modder.transaction do

        @modder.update!(params.require(:modder).permit(
          :name,
          :bio,
          :city,
          :latitude,
          :longitude,
          :featured_link,
          :website_url,
          :etsy_shop,
          :twitter_username,
          :instagram_username,
          :discord_username
        ))

        if current_user.admin?
          @modder.update!(params.require(:modder).permit(:vetting_status))
        end

        @modder.status = params[:modder][:status] if params[:modder][:status].in? [Modder::STATUS_ACTIVE, Modder::STATUS_INACTIVE]
        @modder.logo = params[:modder][:logo]
        @modder.save!

        @modder.modder_services.destroy_all

        services = JSON.parse params[:modder][:services]
        services.each_with_index do |service, index|
          next unless ModderService::ALL_SERVICES[service.to_sym].present?

          @modder.modder_services.create!({
            index:,
            service:
          })
        end

      end

      AdminMailer.with(modder: @modder).new_modder.deliver_later if @modder.user.present? && @onboarding

      flash[:notice] = 'Your profile was updated.'
      redirect_to modder_path(@modder)
    rescue StandardError
      flash[:error] = 'There was a problem saving your profile. See error messages below.'
      @title = @onboarding ? 'Create profile' : 'Edit profile'
      render :edit
    end
  end

  def upload_photo
    photo_count = current_modder.modder_photos.count
    return render json: { success: false } unless photo_count < 10

    modder_photo = ModderPhoto.new({
      modder: current_modder,
      index: photo_count
    })

    modder_photo.photo = params[:photo]

    if modder_photo.save
      render json: {
        success: true,
        photo: {
          uuid: modder_photo.uuid,
          url: modder_photo.photo.thumb.url,
          width: modder_photo.thumb_display_width,
          height: modder_photo.thumb_display_height
        }
      }
    else
      render json: {
        success: false
      }
    end
  end

  def reorder_photos
    ModderPhoto.transaction do
      params[:photos].each_with_index do |uuid, index|
        modder_photo = ModderPhoto.find_by(modder: current_modder, uuid:)
        next if modder_photo.blank?
        modder_photo.index = index
        modder_photo.save!
      end
    end
  end

  def remove_photo
    modder_photo = ModderPhoto.find_by(modder: current_modder, uuid: params[:uuid])
    modder_photo.destroy
  end

end
