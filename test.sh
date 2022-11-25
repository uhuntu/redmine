bundle exec rake db:drop db:create RAILS_ENV=test
bundle exec rake redmine:plugins NAME=redmine_backup RAILS_ENV=test
bundle exec rake db:migrate redmine:plugins:migrate RAILS_ENV=test
bundle exec rake redmine:load_default_data RAILS_ENV=test REDMINE_LANG=en
