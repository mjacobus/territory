# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

namespace :phones do
  desc 'update statuses'
  task update: :environment do
    ActiveRecord::Base.transaction do
      Phone.all.each(&:update_status)
    end
  end
end
