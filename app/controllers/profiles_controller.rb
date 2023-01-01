class ProfilesController < ApplicationController

  before_action :authenticate_user!

  def show
    return redirect_to edit_profile_path if current_modder.blank?
    redirect_to modder_path(current_modder)
  end

  def edit
    @modder = current_modder || Modder.new(user: current_user)
    @onboarding = !@modder.persisted?
  end

  def create
    update
  end

  def update
    @modder = current_modder || Modder.new(user: current_user)
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
          :twitter_username
        ))
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

      flash[:notice] = 'Your profile was updated.'
      redirect_to user_root_path
    rescue StandardError
      flash[:error] = 'There was a problem saving your profile. See error messages below.'
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
          url: modder_photo.photo_url
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
