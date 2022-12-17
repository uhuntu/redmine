bundle exec rake db:drop db:create RAILS_ENV=development
bundle exec rake db:migrate RAILS_ENV=development
bundle exec rake redmine:plugins RAILS_ENV=development
bundle exec rake redmine:load_default_data RAILS_ENV=development REDMINE_LANG=en
