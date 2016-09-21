class Reminder
  attr_reader :rules
  Display_Estate = -> estate { puts "%s | %s due date %s" % [estate[:reminder], estate[:code],estate[:date]]}
  Date_Template = "%e %b %Y"
  End_Of_First_Quarter = 4
  Month = (60 * 60 * 24 * 7 * 4.34)

  def initialize(rules)
    @rules = rules
  end

  def on(date,estates)
    dates = get_dates date,estates
    puts "Estate service charges due for the next service period(#{date.to_date}):"
    puts "   Dates    |  Reminders "
    puts "-------------------------"
    dispay_estate dates
  end


  def get_dates(date,estates)
    estates.inject([]) do |res,estate|
      due_dates = check_if_due estate['due_dates'],estate['service_charge'],date
      due_dates ? res + due_dates.map {|dd|
        due_date = get_due_date(dd,date)
        {
          date: due_date.strftime(Date_Template),
          code: estate['estate_code'],
          reminder: get_reminder(due_date,estate['service_charge'])
        }
      } : res
    end
  end

  def get_due_date(due_date,date)
    mod = (DateTime.parse(due_date).month < End_Of_First_Quarter) ? 1 : 0
    DateTime.parse("#{due_date} #{date.year + mod}")
  end

  def get_reminder(due_date,service_charge)
    (due_date - @rules['days_before'][service_charge]).strftime(Date_Template)
  end
  def dispay_estate(dates)
    dates.each(&Display_Estate)
  end

  private

  def check_if_due(dates,service,for_date)
    res = dates.select {|date| within_next_service_period? for_date,@rules['service_period'][service],date }
    res.empty? ? false : res
  end

  def within_next_service_period?(for_date,month_count,date)
    s_period = service_period(for_date,month_count)
    res = within_date_range(s_period,date,for_date)
    unless res
      res = within_date_range(s_period,date,for_date,1)
    end
    res
  end

  def service_period(for_date,month_count)
  ((s = for_date.to_time.to_i)..(s + to_months(month_count)))
  end

  def within_date_range(range,date,for_date,mod=0)
    range === DateTime.parse("#{date} #{for_date.year + mod}").to_time.to_i
  end

  def to_months(count)
    Month * count
  end
end
