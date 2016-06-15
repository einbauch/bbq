module EventsHelper

  def current_user_can_subscribe_to?(event)
    !current_user_can_edit?(event)
  end

end
