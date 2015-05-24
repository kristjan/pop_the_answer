module UsersHelper
  TIME_ZONE = 'Pacific Time (US & Canada)'

  def accepted_class(answer, question)
    case accepted_state(answer, question)
    when :accepted then 'accepted'
    when :none     then 'undecided'
    else                'not-accepted'
    end
  end

  def accepted_state(answer, question)
    case question.accepted_answer_id
    when answer.answer_id then :accepted
    when nil              then :none
    else                       :another
    end
  end

  def accepted_title(answer, question)
    case accepted_state(answer, question)
    when :accepted then 'Answer was accepted!'
    when :none     then 'No accepted answers yet.'
    else                'Another answer was accepted.'
    end
  end

  def answer_dates(answers)
    answers.map do |answer|
      answer.creation_date.to_time.in_time_zone(TIME_ZONE).to_date
    end.sort.uniq.reverse
  end

  def history(answers)
    answers.group_by do |answer|
      answer.creation_date.to_time.in_time_zone(TIME_ZONE).to_date
    end.sort_by(&:first).reverse.push(nil)
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

  # https://stackoverflow.com/questions/1065320/in-rails-display-time-between-two-dates-in-english
  def date_difference(from_time, to_time)
    from_time = from_time.to_time if from_time.respond_to?(:to_time)
    to_time = to_time.to_time if to_time.respond_to?(:to_time)
    distance_in_seconds = ((to_time - from_time).abs).round
    components = []

    %w(year month week day).each do |interval|
      if distance_in_seconds >= 1.send(interval)
        delta = (distance_in_seconds / 1.send(interval)).floor
        distance_in_seconds -= delta.send(interval)
        components << pluralize(delta, interval)
      end
    end

    components.join(", ")
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
