bundle install

bundle exec rake zeitwerk:check --trace
bundle exec rake db:migrate RAILS_ENV=production

bundle exec rake redmine:plugins NAME=easy_wbs RAILS_ENV=production
bundle exec rake redmine:plugins NAME=000_redmine_x_ux_upgrade RAILS_ENV=production
bundle exec rake redmine:plugins NAME=redmine_agile RAILS_ENV=production
bundle exec rake redmine:plugins NAME=redmine_checklists RAILS_ENV=production
bundle exec rake redmine:plugins NAME=redmine_favorite_projects RAILS_ENV=production
bundle exec rake redmine:plugins NAME=redmine_issues_tree RAILS_ENV=production
bundle exec rake redmine:plugins NAME=redmine_x_agile_my_page RAILS_ENV=production
bundle exec rake redmine:plugins NAME=redmine_x_assets RAILS_ENV=production
bundle exec rake redmine:plugins NAME=redmine_x_gantt RAILS_ENV=production
bundle exec rake redmine:plugins NAME=redmine_x_project_templates RAILS_ENV=production
bundle exec rake redmine:plugins NAME=redmine_x_resources RAILS_ENV=production
bundle exec rake redmine:plugins NAME=redmine_x_statistics RAILS_ENV=production
bundle exec rake redmine:plugins NAME=redmine_dmsf RAILS_ENV=production
bundle exec rake redmine:plugins NAME=redmine_drawio RAILS_ENV=production

bundle exec rake redmine:plugins:migrate NAME=easy_wbs RAILS_ENV=production
bundle exec rake redmine:plugins:migrate NAME=000_redmine_x_ux_upgrade RAILS_ENV=production
bundle exec rake redmine:plugins:migrate NAME=redmine_agile RAILS_ENV=production
bundle exec rake redmine:plugins:migrate NAME=redmine_checklists RAILS_ENV=production
bundle exec rake redmine:plugins:migrate NAME=redmine_favorite_projects RAILS_ENV=production
bundle exec rake redmine:plugins:migrate NAME=redmine_issues_tree RAILS_ENV=production
bundle exec rake redmine:plugins:migrate NAME=redmine_x_agile_my_page RAILS_ENV=production
bundle exec rake redmine:plugins:migrate NAME=redmine_x_assets RAILS_ENV=production
bundle exec rake redmine:plugins:migrate NAME=redmine_x_gantt RAILS_ENV=production
bundle exec rake redmine:plugins:migrate NAME=redmine_x_project_templates RAILS_ENV=production
bundle exec rake redmine:plugins:migrate NAME=redmine_x_resources RAILS_ENV=production
bundle exec rake redmine:plugins:migrate NAME=redmine_x_statistics RAILS_ENV=production
bundle exec rake redmine:plugins:migrate NAME=redmine_dmsf RAILS_ENV=production
bundle exec rake redmine:plugins:migrate NAME=redmine_drawio RAILS_ENV=production

bundle exec rake db:migrate RAILS_ENV=production
bundle exec rake zeitwerk:check --trace
