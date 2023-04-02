# Redmine - project management software
# Copyright (C) 2006-2022  Jean-Philippe Lang
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

require "openai"

namespace :redmine do
  namespace :attachments do
    desc 'Removes uploaded files left unattached after one day.'
    task :prune => :environment do
      Attachment.prune
    end

    desc 'Moves attachments stored at the root of the file directory (ie. created before Redmine 2.3) to their subdirectories'
    task :move_to_subdirectories => :environment do
      Attachment.move_from_root_to_target_directory
    end

    desc 'Updates attachment digests to SHA256'
    task :update_digests => :environment do
      Attachment.update_digests_to_sha256
    end
  end

  namespace :tokens do
    desc 'Removes expired tokens.'
    task :prune => :environment do
      Token.destroy_expired
    end
  end

  namespace :users do
    desc 'Removes registered users that have not been activated after a number of days. Use DAYS to set the number of days, defaults to 30 days.'
    task :prune => :environment do
      days = 30
      env_days = ENV['DAYS']
      if env_days
        if env_days.to_i <= 0
          abort "Invalid DAYS #{env_days} given. The value must be a integer."
        else
          days = env_days.to_i
        end
      end
      User.prune(days.days)
    end
  end

  namespace :watchers do
    desc 'Removes watchers from what they can no longer view.'
    task :prune => :environment do
      Watcher.prune
    end
  end

  desc 'Fetch changesets from the repositories'
  task :fetch_changesets => :environment do
    Repository.fetch_changesets
  end

  desc 'Migrates and copies plugins assets.'
  task :plugins do
    Rake::Task["redmine:plugins:migrate"].invoke
    Rake::Task["redmine:plugins:assets"].invoke
  end

  desc "Migrate Region."
  task :migrate_region => :environment do
    csv = CSV.read("actual.csv", headers: true)
    customers = csv.by_col[0]
    types     = csv.by_col[1]
    regions   = csv.by_col[2]
    Project = Class.new(ActiveRecord::Base)
    CustomValue = Class.new(ActiveRecord::Base)
    Project.establish_connection(:production)
    Project.table_name = "projects"
    CustomValue.establish_connection(:production)
    CustomValue.table_name = "custom_values"
    projects = Project.where(status: 1)
    custom_values = CustomValue.where(customized_type: "Project")
    projects.each do |project|
      custom_value = custom_values.where(customized_id: project[:id])
      custom_field_ids = custom_value.pluck(:custom_field_id)
      if custom_field_ids.include?(34)
        customer = custom_value.where(custom_field_id: 34).pluck(:value)[0]
        if customer != nil && customer != ""
          puts "customer = #{customer}, project id = #{project[:id]}"
          type_csv    = nil
          region_csv  = nil
          if customers.include?(customer)
            type_csv    =   types[customers.index(customer)]
            region_csv  = regions[customers.index(customer)]
          end
          puts "type_csv = #{type_csv}"
          puts "region_csv = #{region_csv}"
          if custom_field_ids.include?(61)
            region = custom_value.where(custom_field_id: 61).pluck(:value)[0]
            if region != nil && region != ""
              puts "region = #{region}"
            else
              if region_csv != nil && region_csv != ""
                region = custom_value.where(custom_field_id: 61)
                region.update(value: region_csv)
              end
            end
          else
            CustomValue.create(customized_type: "Project", customized_id: project[:id], custom_field_id: 61, value: region_csv)
          end
          if custom_field_ids.include?(62)
            type = custom_value.where(custom_field_id: 62).pluck(:value)[0]
            if type != nil && type != ""
              puts "type = #{type}"
            else
              if type_csv != nil && type_csv != ""
                type = custom_value.where(custom_field_id: 62)
                type.update(value: type_csv)
              end
            end
          else
            CustomValue.create(customized_type: "Project", customized_id: project[:id], custom_field_id: 62, value: type_csv)
          end
        end
      end
    end
    Project.remove_connection
    CustomValue.remove_connection
    Object.send(:remove_const, :Project)
    Object.send(:remove_const, :CustomValue)
  end

  desc 'Rediss User.'
  task :rediss_user => :environment do
    puts "Rediss User"
    User.reindex
    user_index = User.search_index
    puts "- user_index for #{user_index}..."
    user_search = user_index.search("hunt")
    user_results = user_search.results.inspect
    puts "- user_results = #{user_results}"
  end

  desc 'Rediss Issue.'
  task :rediss_issue => :environment do
    OpenAI.configure do |config|
      config.access_token = ENV.fetch('OPENAI_ACCESS_TOKEN')
    end
    client = OpenAI::Client.new

    puts "Rediss Issue"
    issue_index = Issue.search_index
    puts "- issue_index for #{issue_index.name}..."

    # issue_index.drop
    issue_index.create

    # issue = Issue.first

    # puts "issue = #{issue}"
    # doc = issue.search_document
    # puts "doc = #{doc.redis_attributes}"
    # puts doc.document_id
    # issue.add_to_index

    Issue.all.each do |issue|
      find = RediSearch::Document.get(issue_index, issue.id)

      puts "find = #{find}"
      puts "id = #{issue.id}"

      if !find.nil?
        next
      end

      subject_text = issue[:subject]
      description_text = issue[:description]
  
      puts "Getting subject_embedding..."
      subject_embed = client.embeddings(
        parameters: {
          model: "text-embedding-ada-002",
          input: subject_text
        }
      )
  
      puts "Getting description_embedding..."
      description_embed = client.embeddings(
        parameters: {
          model: "text-embedding-ada-002",
          input: description_text
        }
      )
  
      subject_data = subject_embed.parsed_response["data"]
      subject_embedding = subject_data[0]["embedding"]
  
      description_data = description_embed.parsed_response["data"]
      description_embedding = description_data[0]["embedding"]
  
      doc = issue.search_document(save: {
        :subject_vector     => subject_embedding.pack("F*"), 
        :description_vector => description_embedding.pack("F*")
      })
      issue_index.add doc  
    end

    # puts "d = #{d.redis_attributes}"
    # fields = issue_index.schema.fields
    # puts "fields = #{fields}"

    # find = RediSearch::Document.get(issue_index, 2)
    # puts "find = #{find}"
    # puts "find.schema_fields = #{find.schema_fields}"
    # puts "find.redis_attributes = #{find.redis_attributes}"
    # issue_search = issue_index.search("tes*")
    # issue_results = issue_search.results.inspect
    # puts "- issue_results = #{issue_results}"
  end

  desc "OpenAI Test"
  task :openai_test => :environment do
    OpenAI.configure do |config|
      config.access_token = ENV.fetch('OPENAI_ACCESS_TOKEN')
    end
    client = OpenAI::Client.new
    list = client.models.list
    puts "list = #{list}"
    model = client.models.retrieve(id: "text-embedding-ada-002")
    puts "model = #{model}"
    embed = client.embeddings(
      parameters: {
        model: "text-embedding-ada-002",
        input: "The food was delicious and the waiter..."
      }
    )
    puts "embed = #{embed}"
    data = embed.parsed_response["data"]
    embedding = data[0]["embedding"]
    puts "embedding = #{embedding.length}"
    # embedding.each do |e|
    #   puts e.class
    # end
  end

  desc 'Migrate Hunt.'
  task :migrate_hunt => :environment do
    ActiveRecord::Base.establish_connection :production
    source_tables = ActiveRecord::Base.connection.tables.sort
    ActiveRecord::Base.remove_connection

    source_tables.each do |table_name|
      Source = Class.new(ActiveRecord::Base)
      Source.establish_connection(:production)
      Source.table_name = table_name
      if table_name == "custom_values"
        customers = Source.where(custom_field_id: 34).group('customized_id')
        counts = customers.count
        counts.each do |count|
          if count[1] == 2
            repeat = Source.where(custom_field_id: 34, customized_id: count[0])
            puts "project_id = #{count[0]}"
            puts "repeat[0]  = #{repeat[0].value}"
            puts "repeat[1]  = #{repeat[1].value}"
            repeat[1].destroy
          end
        end
      end
      # source_count = Source.count
      # puts "Migrating %6d records from #{table_name}..." % source_count
      Object.send(:remove_const, :Source)
    end
  end

desc <<-DESC
FOR EXPERIMENTAL USE ONLY, Moves Redmine data from production database to the development database.
This task should only be used when you need to move data from one DBMS to a different one (eg. MySQL to PostgreSQL).
WARNING: All data in the development database is deleted.
DESC

  task :migrate_dbms => :environment do
    ActiveRecord::Base.establish_connection :development
    target_tables = ActiveRecord::Base.connection.tables
    ActiveRecord::Base.remove_connection

    ActiveRecord::Base.establish_connection :production
    tables = ActiveRecord::Base.connection.tables.sort - %w(schema_migrations plugin_schema_info)

    if (tables - target_tables).any?
      list = (tables - target_tables).map {|table| "* #{table}"}.join("\n")
      abort "The following table(s) are missing from the target database:\n#{list}"
    end

    tables.each do |table_name|
      Source = Class.new(ActiveRecord::Base)
      Target = Class.new(ActiveRecord::Base)
      Target.establish_connection(:development)

      [Source, Target].each do |klass|
        klass.table_name = table_name
        klass.reset_column_information
        klass.inheritance_column = "foo"
        klass.record_timestamps = false
      end
      Target.primary_key = (Target.column_names.include?("id") ? "id" : nil)

      source_count = Source.count
      puts "Migrating %6d records from #{table_name}..." % source_count

      Target.delete_all
      offset = 0
      while (objects = Source.offset(offset).limit(5000).order("1,2").to_a) && objects.any?
        offset += objects.size
        Target.transaction do
          objects.each do |object|
            new_object = Target.new(object.attributes)
            new_object.id = object.id if Target.primary_key
            new_object.save(:validate => false)
          end
        end
      end
      Target.connection.reset_pk_sequence!(table_name) if Target.primary_key
      target_count = Target.count
      abort "Some records were not migrated" unless source_count == target_count

      Object.send(:remove_const, :Target)
      Object.send(:remove_const, :Source)
    end
  end

  namespace :plugins do
    desc 'Migrates installed plugins.'
    task :migrate => :environment do
      name = ENV['NAME']
      version = nil
      version_string = ENV['VERSION']
      if version_string
        if version_string =~ /^\d+$/
          version = version_string.to_i
          if name.nil?
            abort "The VERSION argument requires a plugin NAME."
          end
        else
          abort "Invalid VERSION #{version_string} given."
        end
      end

      begin
        Redmine::Plugin.migrate(name, version)
      rescue Redmine::PluginNotFound
        abort "Plugin #{name} was not found."
      end

      case ActiveRecord::Base.schema_format
      when :ruby
        Rake::Task["db:schema:dump"].invoke
      when :sql
        Rake::Task["db:structure:dump"].invoke
      end
    end

    desc 'Copies plugins assets into the public directory.'
    task :assets => :environment do
      name = ENV['NAME']

      begin
        Redmine::PluginLoader.mirror_assets(name)
      rescue Redmine::PluginNotFound
        abort "Plugin #{name} was not found."
      end
    end

    desc 'Runs the plugins tests.'
    task :test do
      Rake::Task["redmine:plugins:test:units"].invoke
      Rake::Task["redmine:plugins:test:functionals"].invoke
      Rake::Task["redmine:plugins:test:integration"].invoke
      Rake::Task["redmine:plugins:test:system"].invoke
    end

    namespace :test do
      desc 'Runs the plugins unit tests.'
      task :units => "db:test:prepare" do |t|
        $: << "test"
        Rails::TestUnit::Runner.rake_run ["plugins/#{ENV['NAME'] || '*'}/test/unit/**/*_test.rb"]
      end

      desc 'Runs the plugins functional tests.'
      task :functionals => "db:test:prepare" do |t|
        $: << "test"
        Rails::TestUnit::Runner.rake_run ["plugins/#{ENV['NAME'] || '*'}/test/functional/**/*_test.rb"]
      end

      desc 'Runs the plugins integration tests.'
      task :integration => "db:test:prepare" do |t|
        $: << "test"
        Rails::TestUnit::Runner.rake_run ["plugins/#{ENV['NAME'] || '*'}/test/integration/**/*_test.rb"]
      end

      desc 'Runs the plugins system tests.'
      task :system => "db:test:prepare" do |t|
        $: << "test"
        Rails::TestUnit::Runner.rake_run ["plugins/#{ENV['NAME'] || '*'}/test/system/**/*_test.rb"]
      end

      desc 'Runs the plugins ui tests.'
      task :ui => "db:test:prepare" do |t|
        $: << "test"
        Rails::TestUnit::Runner.rake_run ["plugins/#{ENV['NAME'] || '*'}/test/ui/**/*_test.rb"]
      end
    end
  end
end

# Load plugins' rake tasks
Dir[File.join(Rails.root, "plugins/*/lib/tasks/**/*.rake")].sort.each { |ext| load ext }
