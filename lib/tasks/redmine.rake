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

#require "openai"

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

  desc "Rediss Search."
  task :rediss_search => :environment do
    OpenAI.configure do |config|
      config.access_token = ENV.fetch('OPENAI_ACCESS_TOKEN')
      config.http_proxy = ENV.fetch('http_proxy')
    end
    client = OpenAI::Client.new

    query_text = "请告诉我一些超标的问题"

    puts "Getting query_embedding..."
    query_embed = client.embeddings(
      parameters: {
        model: "text-embedding-ada-002",
        input: query_text
      }
    )

    query_data = query_embed.parsed_response["data"]
    query_embedding = query_data[0]["embedding"] if !query_data.nil?

    if query_data.nil?
      puts "query_data is nil"
      puts query_embed["error"]
      puts query_text.nil?
      abort
    end

    query_pack = query_embedding.pack("F*") if !query_embedding.nil?
    abort if query_pack.nil?

    puts "Rediss Search"
    issue_index = Issue.search_index
    puts "- issue_index for #{issue_index.name}..."

    index_search = issue_index
      .search("*=>[KNN 10 @subject_vector $vector AS vector_score]")
      .return(:subject, :description, :vector_score)
      .sort_by(:subject)
      .limit(10)
      .dialect(2)

    index_search = index_search
      .params(:vector, query_pack) if !query_pack.nil?

    index_results = index_search.results
    # index_inspect = index_results.inspect
    puts index_results.pluck(:subject, :description)
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

    Issue.all.each do |issue|
      find = RediSearch::Document.get(issue_index, issue.id)

      puts "find = #{find}"
      puts "id = #{issue.id}"

      subject_text = issue[:subject]
      description_text = issue[:description]

      if description_text.nil? || description_text.empty?
        if !find.nil?
          issue.remove_from_index
        end
        next
      end
  
      if !find.nil?
        next
      end

      puts "Getting subject_embedding..."
      subject_embed = client.embeddings(
        parameters: {
          model: "text-embedding-ada-002",
          input: subject_text
        }
      )

      subject_data = subject_embed.parsed_response["data"]
      subject_embedding = subject_data[0]["embedding"] if !subject_data.nil?

      if subject_data.nil?
        puts "subject_data is nil"
        puts subject_embed["error"]
        puts subject_text.nil?
        sleep 10
      end

      puts "Getting description_embedding..."
      description_embed = client.embeddings(
        parameters: {
          model: "text-embedding-ada-002",
          input: description_text
        }
      )
  
      description_data = description_embed.parsed_response["data"]
      description_embedding = description_data[0]["embedding"] if !description_data.nil?
  
      if description_data.nil?
        puts "description_data is nil"
        puts description_embed["error"]
        puts description_text.nil?
        sleep 10
      end

      issue_doc = issue.search_document(save: {
        :subject_vector     => subject_embedding.pack("F*"), 
        :description_vector => description_embedding.pack("F*")
      }) if !subject_embedding.nil? && !description_embedding.nil?

      issue_index.add issue_doc if !issue_doc.nil?

      if issue_doc.nil?
        puts "Skipping..."
      else
        puts "Inserted..."
      end
    end
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
