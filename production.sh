bundle exec rake db:migrate RAILS_ENV=production
bundle exec rake redmine:plugins RAILS_ENV=production
bundle exec rake redmine:load_default_data RAILS_ENV=production REDMINE_LANG=en
