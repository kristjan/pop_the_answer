module UsersHelper
  TIME_ZONE = 'Pacific Time (US & Canada)'
  def answer_dates(answers)
    answers.map do |answer|
      answer.creation_date.to_time.in_time_zone(TIME_ZONE).to_date
    end.sort.uniq.reverse
  end

  def answers_by_date(answers)
    answers.group_by do |answer|
      answer.creation_date.to_time.in_time_zone(TIME_ZONE).to_date
    end.sort_by(&:first).reverse
  end

  def current_streak(answers)
    dates = answer_dates(answers)
    return 0 if dates.empty?
    return 0 unless dates.first.in?([today, today - 1])
    required = dates.first
    count = 0
    count += 1 and required -= 1 while dates.shift == required
    count
  end

  def date_slices(dates)
    dates.slice_when { |newer, older| newer != older + 1 }
  end

  def longest_streak(answers)
    date_slices(answer_dates(answers)).map(&:size).max
  end

  def today
    Time.now.in_time_zone(TIME_ZONE).to_date
  end
end
