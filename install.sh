bundle install
bundle update

bundle exec rake zeitwerk:check --trace
bundle exec rake db:migrate RAILS_ENV=production
bundle exec rake redmine:plugins RAILS_ENV=production

