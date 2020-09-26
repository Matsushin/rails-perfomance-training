class SlowQueryLogger
  MAX_DURATION_SECOND = 1

  def self.initialize!
    ActiveSupport::Notifications.subscribe('sql.active_record') do |_name, start, finish, id, payload|
      duration = finish.to_f - start.to_f

      if duration >= MAX_DURATION_SECOND
        Rails.logger.info("slow query detected: #{payload[:sql]}, duration: #{duration}")
      end
    end
  end
end

SlowQueryLogger.initialize!