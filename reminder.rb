class Reminder
  attr_reader :rules
  def initialize(rules)
    @rules = rules
  end

  def on(date,estates)
    dates = get_dates date,estates
    puts "Estate service charges due for the next service period(#{date.to_date}):"
    dispay_estate dates
  end


  def get_dates(date,estates)
    estates.inject([]) do |res,estate|
      due_dates = check_if_due estate['due_dates'],estate['service_charge'],date
      due_dates ? res + due_dates.map {|d| {date: d, code: estate['estate_code']}} : res
    end
  end

  def dispay_estate(dates)
    dates.each do |estate|
      puts "#{estate[:code]} due date #{estate[:date]}"
    end
  end

  private

  def check_if_due(dates,service,for_date)
    res = dates.select {|date| within_next_service_period? for_date,@rules[service],date }
    res.empty? ? false : res
  end

  def within_next_service_period?(for_date,month_count,date)
    start_date = for_date.to_time.to_i
    end_date = start_date + to_months(month_count)
    res = (start_date..end_date) === DateTime.parse("#{date} #{for_date.year}").to_time.to_i #checks this year
    unless res
      res = (start_date..end_date) === DateTime.parse("#{date} #{for_date.year + 1}").to_time.to_i #checks next year
    end
    res
  end

  def get_year(end_date,date)
    if (end_year = Time.at(end_date).to_datetime.year) > date.year
      end_year
    else
      date.year
    end
  end

  def to_months(count)
    (@month ||= 60 * 60 * 24 * 7 * 4.34) * count
  end
end
