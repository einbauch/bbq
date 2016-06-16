class PhotosController < ApplicationController
  before_action :set_event, only: [:create, :destroy]
  before_action :set_photo, only: [:destroy]

  # POST /photos
  def create
    @new_photo = @event.photos.build(photo_params)
    @new_photo.user = current_user

    if @new_photo.save
      notify_subscribers(@event, @new_photo)

      redirect_to @event, notice: I18n.t('controllers.photos.created')
    else
      flash.now[:alert] = I18n.t('controllers.photos.error')
      render 'events/show'
    end
  end

  # DELETE /photos/1
  def destroy
    message = {notice: I18n.t('controllers.photos.destroyed')}

    if current_user_can_edit?(@photo)
      @photo.destroy
    else
      message = {alert: I18n.t('controllers.photos.error')}
    end

    redirect_to @event, message
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end
    # Use callbacks to share common setup or constraints between actions.
  def set_photo
    @photo = Photo.find(params[:id])
  end

    # Only allow a trusted parameter "white list" through.
  def photo_params
    params.fetch(:photo, {}).permit(:photo)
  end

  def notify_subscribers(event, photo)
    # собираем всех подписчиков и автора события в массив мэйлов, исключаем повторяющиеся
    all_emails = (event.subscriptions.map(&:user_email) + [event.user.email]).uniq

    all_emails.delete(current_user.email) if user_signed_in?

    # XXX: Этот метод может выполняться долго из-за большого числа подписчиков
    # поэтому в реальных приложениях такие вещи надо выносить в background задачи!
    all_emails.each do |mail|
      EventMailer.photo(event, photo, mail).deliver_now
    end
  end

end
