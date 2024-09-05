namespace :backfills do

  task backfill_modder_visibility: [:environment] do
    Modder.all.each do |modder|
      modder.visibility = case modder.status
      when Modder::STATUS_ACTIVE
        Modder::VISIBILITY_VISIBLE
      when Modder::STATUS_INACTIVE
        Modder::VISIBILITY_HIDDEN
      end
      puts "Updating modder #{modder.slug} to #{modder.visibility} because status is #{modder.status}"
      modder.record_timestamps = false
      modder.save!
    end
  end

end
