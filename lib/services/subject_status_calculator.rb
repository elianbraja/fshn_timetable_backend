module Services
  module SubjectStatusCalculator

    def self.calculate_status_of(time)

      day_index = Time.current.in_time_zone('Rome').wday
      return nil if [0, 6, 7].include? day_index

      times = time.split("-").map(&:strip)

      if parse_time(Time.now).between?(parse_time(times[0]), parse_time(times[1]))
        "now"
      elsif parse_time(Time.now) < parse_time(times[0])
        "upcoming"
      elsif parse_time(Time.now) > parse_time(times[1])
        "completed"
      else
        nil
      end
    end

    def self.parse_time(time)
      time.in_time_zone('Rome')
    end

  end
end