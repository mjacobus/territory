# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

namespace :app do
  namespace :data do
    desc 'populate phone action'
    task populate_phone_action: :environment do
      ActiveRecord::Base.transaction do
        Tasks::ActionCodeMigrator.new.migrate
      end
    end
  end
end
