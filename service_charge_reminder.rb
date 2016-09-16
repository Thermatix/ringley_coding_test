require_relative 'reminder'
require_relative 'helpers'
require 'date'

estates = load_yml('estates.yml')
reminder_rules = load_yml('rules.yml')
date = DateTime.now

reminder = Reminder.new(reminder_rules)
reminder.on(date, estates)
