bundle install

bundle exec rake zeitwerk:check --trace

bundle exec rake db:migrate RAILS_ENV=production

bundle exec rake redmine:plugins NAME=easy_mindmup RAILS_ENV=production
bundle exec rake redmine:plugins NAME=easy_wbs RAILS_ENV=production

bundle exec rake redmine:plugins NAME=000_redmine_x_ux_upgrade RAILS_ENV=production

bundle exec rake redmine:plugins:migrate RAILS_ENV=production
