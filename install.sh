bundle install
bundle update

bundle exec rake db:migrate RAILS_ENV=production
bundle exec rake redmine:plugins RAILS_ENV=production

bundle exec rake zeitwerk:check --trace RAILS_ENV=production

bundle exec rake full_text_search:synchronize RAILS_ENV=production

sudo service apache2 restart
