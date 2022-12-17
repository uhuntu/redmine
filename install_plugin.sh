bundle install

bundle exec rake zeitwerk:check --trace
bundle exec rake db:migrate RAILS_ENV=production

bundle exec rake redmine:plugins NAME=redmine_agile RAILS_ENV=production
bundle exec rake redmine:plugins:migrate NAME=redmine_agile RAILS_ENV=production

bundle exec rake db:migrate RAILS_ENV=production
bundle exec rake zeitwerk:check --trace

bundle install
