namespace :modders do

  task warn_inactive: [:environment] do
    inactive_users = User
      .joins(:modder)
      .where('last_active_at < ?', 180.days.ago)
      .or(User.where(last_active_at: nil))
      .where(inactive_warning_sent_at: nil)
      .where(modder: { status: Modder::STATUS_ACTIVE })
      .order(last_active_at: :desc)
      .limit(10)

    Rails.logger.info "Found #{inactive_users.count} inactive users"

    inactive_users.each do |user|
      UserMailer.with(user_id: user.id).warn_inactive.deliver_now
      user.touch :inactive_warning_sent_at

      sleep 5
    end
  end

  task mark_inactive: [:environment] do
    users_to_mark_inactive = User
      .joins(:modder)
      .where('inactive_warning_sent_at < ?', 2.weeks.ago)
      .where(modder: { status: Modder::STATUS_ACTIVE })

    Rails.logger.info "Found #{users_to_mark_inactive.count} users to mark inactive"

    users_to_mark_inactive.each do |user|
      modder = user.modder
      modder.status = Modder::STATUS_INACTIVE
      modder.save

      Rails.logger.info "Marked modder #{modder.name} inactive"
      EventLog.log 'marked_modder_inactive', user_id: user.id, modder_id: modder.id, modder_slug: modder.slug

      UserMailer.with(user_id: user.id).mark_inactive.deliver_now
    end
  end

end
