bundle exec rake db:drop RAILS_ENV=production
bundle exec rake db:create RAILS_ENV=production
bundle exec rake db:migrate RAILS_ENV=production
bundle exec rake redmine:plugins RAILS_ENV=production
bundle exec rake redmine:load_default_data RAILS_ENV=production REDMINE_LANG=en
