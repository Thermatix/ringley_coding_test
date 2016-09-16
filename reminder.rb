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
      du_d = check_if_due estate['due_dates'],estate['service_charge'],date
      du_d ? res + du_d.map {|d| {date: d, code: estate['estate_code']}} : res
    end
  end

  def dispay_estate(dates)
    dates.each do |estate|
      puts "#{estate[:code]} due date #{estate[:date]}"
    end
  end

  private

  def check_if_due(dates,service,for_date)
    res = dates.select {|date| within_next_service_perdiod? for_date,@rules[service],date }
    res.empty? ? false : res
  end

  def within_next_service_perdiod?(for_date,month_count,date)
    f_d = for_date.to_time.to_i
    (f_d..(f_d + to_months(month_count))) === DateTime.parse("#{date} #{for_date.year}").to_time.to_i
  end

  def to_months(count)
    (@month ||= 60 * 60 * 24 * 7 * 4.34) * count
  end
end
