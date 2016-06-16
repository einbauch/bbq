module EventsHelper

  def current_user_can_subscribe_to?(event)
    if user_signed_in?
      event.visitors.exclude?(current_user)
    else
      true
    end
  end

end



