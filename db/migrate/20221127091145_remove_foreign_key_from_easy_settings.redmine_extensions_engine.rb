# This migration comes from redmine_extensions_engine (originally 20190206121100)
class RemoveForeignKeyFromEasySettings < ActiveRecord::Migration[4.2]
  def up
    begin
      remove_foreign_key :easy_settings, :projects
    rescue # rails 5 - if foreign_key_exists? :easy_settings, :projects
    end
  end

  def down
  end
end
