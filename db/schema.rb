# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_10_14_080258) do

  create_table "addresses", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "street1"
    t.string "street2"
    t.string "city"
    t.string "region"
    t.string "postcode"
    t.string "country_code", limit: 2
    t.text "full_address"
    t.string "address_type", limit: 16
    t.string "addressable_type"
    t.integer "addressable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address_type"], name: "index_addresses_on_address_type"
    t.index ["addressable_id", "addressable_type"], name: "index_addresses_on_addressable_id_and_addressable_type"
  end

  create_table "agile_colors", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "container_type"
    t.integer "container_id"
    t.string "color"
    t.index ["container_id"], name: "index_agile_colors_on_container_id"
    t.index ["container_type"], name: "index_agile_colors_on_container_type"
  end

  create_table "agile_data", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "issue_id"
    t.integer "position"
    t.integer "story_points"
    t.integer "agile_sprint_id"
    t.index ["issue_id"], name: "index_agile_data_on_issue_id"
    t.index ["position"], name: "index_agile_data_on_position"
  end

  create_table "agile_sprints", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "project_id"
    t.string "name", null: false
    t.text "description"
    t.integer "status", default: 0, null: false
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sharing", default: 0, null: false
  end

  create_table "attachments", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "container_id"
    t.string "container_type", limit: 30
    t.string "filename", default: "", null: false
    t.string "disk_filename", default: "", null: false
    t.bigint "filesize", default: 0, null: false
    t.string "content_type", default: ""
    t.string "digest", limit: 64, default: "", null: false
    t.integer "downloads", default: 0, null: false
    t.integer "author_id", default: 0, null: false
    t.timestamp "created_on"
    t.string "description"
    t.string "disk_directory"
    t.index ["author_id"], name: "index_attachments_on_author_id"
    t.index ["container_id", "container_type"], name: "index_attachments_on_container_id_and_container_type"
    t.index ["created_on"], name: "index_attachments_on_created_on"
    t.index ["disk_filename"], name: "index_attachments_on_disk_filename"
  end

  create_table "auth_sources", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "type", limit: 30, default: "", null: false
    t.string "name", limit: 60, default: "", null: false
    t.string "host", limit: 60
    t.integer "port"
    t.string "account"
    t.string "account_password", default: ""
    t.string "base_dn"
    t.string "attr_login", limit: 30
    t.string "attr_firstname", limit: 30
    t.string "attr_lastname", limit: 30
    t.string "attr_mail", limit: 30
    t.boolean "onthefly_register", default: false, null: false
    t.boolean "tls", default: false, null: false
    t.text "filter"
    t.integer "timeout"
    t.boolean "verify_peer", default: true, null: false
    t.index ["id", "type"], name: "index_auth_sources_on_id_and_type"
  end

  create_table "backups", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "backup"
    t.integer "time"
    t.integer "date"
  end

  create_table "boards", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "project_id", null: false
    t.string "name", default: "", null: false
    t.string "description"
    t.integer "position"
    t.integer "topics_count", default: 0, null: false
    t.integer "messages_count", default: 0, null: false
    t.integer "last_message_id"
    t.integer "parent_id"
    t.index ["last_message_id"], name: "index_boards_on_last_message_id"
    t.index ["project_id"], name: "boards_project_id"
  end

  create_table "canned_responses", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "name"
    t.text "content"
    t.integer "project_id"
    t.integer "user_id"
    t.boolean "is_public"
  end

  create_table "changes", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "changeset_id", null: false
    t.string "action", limit: 1, default: "", null: false
    t.text "path", null: false
    t.text "from_path"
    t.string "from_revision"
    t.string "revision"
    t.string "branch"
    t.index ["changeset_id"], name: "changesets_changeset_id"
  end

  create_table "changeset_parents", id: false, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "changeset_id", null: false
    t.integer "parent_id", null: false
    t.index ["changeset_id"], name: "changeset_parents_changeset_ids"
    t.index ["parent_id"], name: "changeset_parents_parent_ids"
  end

  create_table "changesets", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "repository_id", null: false
    t.string "revision", null: false
    t.string "committer"
    t.datetime "committed_on", null: false
    t.text "comments", size: :long
    t.date "commit_date"
    t.string "scmid"
    t.integer "user_id"
    t.index ["committed_on"], name: "index_changesets_on_committed_on"
    t.index ["repository_id", "revision"], name: "changesets_repos_rev", unique: true
    t.index ["repository_id", "scmid"], name: "changesets_repos_scmid"
    t.index ["repository_id"], name: "index_changesets_on_repository_id"
    t.index ["user_id"], name: "index_changesets_on_user_id"
  end

  create_table "changesets_issues", id: false, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "changeset_id", null: false
    t.integer "issue_id", null: false
    t.index ["changeset_id", "issue_id"], name: "changesets_issues_ids", unique: true
    t.index ["issue_id"], name: "index_changesets_issues_on_issue_id"
  end

  create_table "checklist_template_categories", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "name"
    t.integer "position", default: 1
  end

  create_table "checklist_templates", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "name"
    t.integer "project_id"
    t.integer "category_id"
    t.integer "user_id"
    t.boolean "is_public"
    t.text "template_items"
    t.boolean "is_default", default: false
    t.integer "tracker_id"
    t.index ["tracker_id"], name: "index_checklist_templates_on_tracker_id"
  end

  create_table "checklists", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.boolean "is_done", default: false
    t.string "subject", limit: 512
    t.integer "position", default: 1
    t.integer "issue_id", null: false
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.boolean "is_section", default: false
  end

  create_table "comments", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "commented_type", limit: 30, default: "", null: false
    t.integer "commented_id", default: 0, null: false
    t.integer "author_id", default: 0, null: false
    t.text "content"
    t.datetime "created_on", null: false
    t.datetime "updated_on", null: false
    t.index ["author_id"], name: "index_comments_on_author_id"
    t.index ["commented_id", "commented_type"], name: "index_comments_on_commented_id_and_commented_type"
  end

  create_table "contacts", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "middle_name"
    t.string "company"
    t.string "phone"
    t.string "email"
    t.string "website"
    t.string "skype_name"
    t.date "birthday"
    t.string "avatar"
    t.text "background"
    t.string "job_title"
    t.boolean "is_company", default: false
    t.integer "author_id", default: 0, null: false
    t.integer "assigned_to_id"
    t.datetime "created_on"
    t.datetime "updated_on"
    t.string "cached_tag_list"
    t.integer "visibility", default: 0, null: false
    t.index ["assigned_to_id"], name: "index_contacts_on_assigned_to_id"
    t.index ["author_id"], name: "index_contacts_on_author_id"
    t.index ["company"], name: "index_contacts_on_company"
    t.index ["email"], name: "index_contacts_on_email"
    t.index ["first_name"], name: "index_contacts_on_first_name"
    t.index ["is_company"], name: "index_contacts_on_is_company"
  end

  create_table "contacts_deals", id: false, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "deal_id"
    t.integer "contact_id"
    t.index ["contact_id"], name: "index_contacts_deals_on_contact_id"
    t.index ["deal_id"], name: "index_contacts_deals_on_deal_id"
  end

  create_table "contacts_issues", id: false, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "issue_id", default: 0, null: false
    t.integer "contact_id", default: 0, null: false
    t.index ["contact_id"], name: "index_contacts_issues_on_contact_id"
    t.index ["issue_id"], name: "index_contacts_issues_on_issue_id"
  end

  create_table "contacts_projects", id: false, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "project_id", default: 0, null: false
    t.integer "contact_id", default: 0, null: false
    t.index ["contact_id"], name: "index_contacts_projects_on_contact_id"
    t.index ["project_id"], name: "index_contacts_projects_on_project_id"
  end

  create_table "contacts_queries", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "project_id"
    t.string "name", default: "", null: false
    t.text "filters"
    t.integer "user_id", default: 0, null: false
    t.boolean "is_public", default: false, null: false
    t.text "column_names"
    t.text "sort_criteria"
    t.string "group_by"
    t.string "type"
    t.index ["project_id"], name: "index_contacts_queries_on_project_id"
    t.index ["user_id"], name: "index_contacts_queries_on_user_id"
  end

  create_table "custom_field_enumerations", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "custom_field_id", null: false
    t.string "name", null: false
    t.boolean "active", default: true, null: false
    t.integer "position", default: 1, null: false
  end

  create_table "custom_fields", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "type", limit: 30, default: "", null: false
    t.string "name", limit: 30, default: "", null: false
    t.string "field_format", limit: 30, default: "", null: false
    t.text "possible_values"
    t.string "regexp", default: ""
    t.integer "min_length"
    t.integer "max_length"
    t.boolean "is_required", default: false, null: false
    t.boolean "is_for_all", default: false, null: false
    t.boolean "is_filter", default: false, null: false
    t.integer "position"
    t.boolean "searchable", default: false
    t.text "default_value"
    t.boolean "editable", default: true
    t.boolean "visible", default: true, null: false
    t.boolean "multiple", default: false
    t.text "format_store"
    t.text "description"
    t.boolean "dmsf_not_inheritable"
    t.index ["id", "type"], name: "index_custom_fields_on_id_and_type"
  end

  create_table "custom_fields_projects", id: false, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "custom_field_id", default: 0, null: false
    t.integer "project_id", default: 0, null: false
    t.index ["custom_field_id", "project_id"], name: "index_custom_fields_projects_on_custom_field_id_and_project_id", unique: true
  end

  create_table "custom_fields_roles", id: false, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "custom_field_id", null: false
    t.integer "role_id", null: false
    t.index ["custom_field_id", "role_id"], name: "custom_fields_roles_ids", unique: true
  end

  create_table "custom_fields_trackers", id: false, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "custom_field_id", default: 0, null: false
    t.integer "tracker_id", default: 0, null: false
    t.index ["custom_field_id", "tracker_id"], name: "index_custom_fields_trackers_on_custom_field_id_and_tracker_id", unique: true
  end

  create_table "custom_values", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "customized_type", limit: 30, default: "", null: false
    t.integer "customized_id", default: 0, null: false
    t.integer "custom_field_id", default: 0, null: false
    t.text "value", size: :long
    t.index ["custom_field_id"], name: "index_custom_values_on_custom_field_id"
    t.index ["customized_type", "customized_id"], name: "custom_values_customized"
  end

  create_table "dashboard_roles", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "dashboard_id", null: false
    t.integer "role_id", null: false
    t.index ["dashboard_id", "role_id"], name: "dashboard_role_ids", unique: true
    t.index ["dashboard_id"], name: "index_dashboard_roles_on_dashboard_id"
    t.index ["role_id"], name: "index_dashboard_roles_on_role_id"
  end

  create_table "dashboards", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.string "dashboard_type", limit: 30, default: "", null: false
    t.boolean "system_default", default: false, null: false
    t.boolean "always_expose", default: false, null: false
    t.boolean "enable_sidebar", default: false, null: false
    t.integer "project_id"
    t.integer "author_id", null: false
    t.integer "visibility", default: 0, null: false
    t.text "options"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_dashboards_on_author_id"
    t.index ["name"], name: "index_dashboards_on_name"
    t.index ["project_id"], name: "index_dashboards_on_project_id"
    t.index ["visibility"], name: "index_dashboards_on_visibility"
  end

  create_table "deal_categories", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "name", null: false
    t.integer "project_id"
    t.index ["project_id"], name: "index_deal_categories_on_project_id"
  end

  create_table "deal_processes", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "deal_id", null: false
    t.integer "author_id", null: false
    t.integer "old_value"
    t.integer "value", null: false
    t.datetime "created_at"
    t.index ["author_id"], name: "index_deal_processes_on_author_id"
    t.index ["deal_id"], name: "index_deal_processes_on_deal_id"
  end

  create_table "deal_statuses", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "name", null: false
    t.integer "position"
    t.boolean "is_default", default: false, null: false
    t.integer "color", default: 11184810, null: false
    t.integer "status_type", default: 0, null: false
  end

  create_table "deal_statuses_projects", id: false, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "project_id", default: 0, null: false
    t.integer "deal_status_id", default: 0, null: false
    t.index ["project_id", "deal_status_id"], name: "index_deal_statuses_projects_on_project_id_and_deal_status_id"
  end

  create_table "deals", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "name"
    t.text "background"
    t.string "currency"
    t.integer "duration", default: 1
    t.decimal "price", precision: 20, scale: 2
    t.integer "price_type"
    t.integer "project_id"
    t.integer "author_id"
    t.integer "assigned_to_id"
    t.integer "status_id"
    t.integer "contact_id"
    t.integer "category_id"
    t.datetime "created_on"
    t.datetime "updated_on"
    t.timestamp "due_date"
    t.integer "probability"
    t.index ["author_id"], name: "index_deals_on_author_id"
    t.index ["category_id"], name: "index_deals_on_category_id"
    t.index ["contact_id"], name: "index_deals_on_contact_id"
    t.index ["project_id"], name: "index_deals_on_project_id"
    t.index ["status_id"], name: "index_deals_on_status_id"
  end

  create_table "deals_issues", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "issue_id", default: 0, null: false
    t.integer "deal_id", default: 0, null: false
    t.index ["deal_id"], name: "index_deals_issues_on_deal_id"
    t.index ["issue_id"], name: "index_deals_issues_on_issue_id"
  end

  create_table "dmsf_file_revision_accesses", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "dmsf_file_revision_id", null: false
    t.integer "action", default: 0, null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dmsf_file_revision_id"], name: "index_dmsf_file_revision_accesses_on_dmsf_file_revision_id"
  end

  create_table "dmsf_file_revisions", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "dmsf_file_id", null: false
    t.integer "source_dmsf_file_revision_id"
    t.string "name", null: false
    t.string "disk_filename", null: false
    t.bigint "size"
    t.string "mime_type"
    t.string "title", null: false
    t.text "description"
    t.integer "workflow"
    t.integer "major_version", null: false
    t.integer "minor_version", null: false
    t.integer "patch_version"
    t.text "comment"
    t.integer "deleted", default: 0, null: false
    t.integer "deleted_by_user_id"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "dmsf_workflow_id"
    t.integer "dmsf_workflow_assigned_by_user_id"
    t.datetime "dmsf_workflow_assigned_at"
    t.integer "dmsf_workflow_started_by_user_id"
    t.datetime "dmsf_workflow_started_at"
    t.string "digest", limit: 64, default: "", null: false
    t.index ["dmsf_file_id"], name: "index_dmsf_file_revisions_on_dmsf_file_id"
  end

  create_table "dmsf_files", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "project_id", null: false
    t.integer "dmsf_folder_id"
    t.string "name", null: false
    t.boolean "notification", default: false
    t.integer "deleted", default: 0, null: false
    t.integer "deleted_by_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dmsf_folder_id"], name: "index_dmsf_files_on_dmsf_folder_id"
    t.index ["project_id"], name: "index_dmsf_files_on_project_id"
  end

  create_table "dmsf_folder_permissions", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "dmsf_folder_id"
    t.integer "object_id", null: false
    t.string "object_type", limit: 30, null: false
    t.index ["dmsf_folder_id"], name: "index_dmsf_folder_permissions_on_dmsf_folder_id"
  end

  create_table "dmsf_folders", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "project_id", null: false
    t.integer "dmsf_folder_id"
    t.string "title", null: false
    t.text "description"
    t.boolean "notification", default: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "deleted", default: 0, null: false
    t.integer "deleted_by_user_id"
    t.boolean "system", default: false, null: false
    t.index ["dmsf_folder_id"], name: "index_dmsf_folders_on_dmsf_folder_id"
    t.index ["project_id"], name: "index_dmsf_folders_on_project_id"
  end

  create_table "dmsf_links", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "target_project_id", null: false
    t.integer "target_id"
    t.string "target_type", limit: 10, null: false
    t.string "name", null: false
    t.integer "project_id", null: false
    t.integer "dmsf_folder_id"
    t.integer "deleted", default: 0, null: false
    t.integer "deleted_by_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "external_url"
    t.integer "user_id"
    t.index ["dmsf_folder_id"], name: "index_dmsf_links_on_dmsf_folder_id"
    t.index ["project_id"], name: "index_dmsf_links_on_project_id"
  end

  create_table "dmsf_locks", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "entity_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "entity_type", null: false
    t.integer "lock_type_cd", null: false
    t.integer "lock_scope_cd", null: false
    t.string "uuid", limit: 36
    t.datetime "expires_at"
    t.integer "dmsf_file_last_revision_id"
    t.string "owner"
    t.index ["entity_id", "entity_type"], name: "index_dmsf_locks_on_entity_id_and_entity_type"
  end

  create_table "dmsf_public_urls", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "token", limit: 32, null: false
    t.integer "dmsf_file_id", null: false
    t.integer "user_id", null: false
    t.datetime "expire_at", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["token"], name: "index_dmsf_public_urls_on_token"
  end

  create_table "dmsf_workflow_step_actions", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "dmsf_workflow_step_assignment_id", null: false
    t.integer "action", null: false
    t.text "note"
    t.timestamp "created_at", default: -> { "current_timestamp()" }, null: false
    t.integer "author_id", null: false
    t.index ["dmsf_workflow_step_assignment_id"], name: "idx_dmsf_wfstepact_on_wfstepassign_id"
  end

  create_table "dmsf_workflow_step_assignments", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "dmsf_workflow_step_id", null: false
    t.integer "user_id", null: false
    t.integer "dmsf_file_revision_id", null: false
    t.index ["dmsf_workflow_step_id", "dmsf_file_revision_id"], name: "index_dmsf_wrkfl_step_assigns_on_wrkfl_step_id_and_frev_id", unique: true
  end

  create_table "dmsf_workflow_steps", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "dmsf_workflow_id", null: false
    t.integer "step", null: false
    t.integer "user_id", null: false
    t.integer "operator", null: false
    t.string "name", limit: 30
    t.index ["dmsf_workflow_id"], name: "index_dmsf_workflow_steps_on_dmsf_workflow_id"
  end

  create_table "dmsf_workflows", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "name", null: false
    t.integer "project_id"
    t.integer "status", default: 1, null: false
    t.timestamp "updated_on"
    t.datetime "created_on"
    t.integer "author_id"
  end

  create_table "documents", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "project_id", default: 0, null: false
    t.integer "category_id", default: 0, null: false
    t.string "title", default: "", null: false
    t.text "description"
    t.timestamp "created_on"
    t.index ["category_id"], name: "index_documents_on_category_id"
    t.index ["created_on"], name: "index_documents_on_created_on"
    t.index ["project_id"], name: "documents_project_id"
  end

  create_table "easy_entity_assignments", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "entity_from_type"
    t.integer "entity_from_id"
    t.string "entity_to_type"
    t.integer "entity_to_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["entity_from_id"], name: "entity_assignment_idx_from"
    t.index ["entity_from_type", "entity_from_id", "entity_to_type", "entity_to_id"], name: "entity_assignment_idx", unique: true
    t.index ["entity_to_id"], name: "entity_assignment_idx_to"
  end

  create_table "easy_settings", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "type"
    t.string "name"
    t.text "value"
    t.integer "project_id"
    t.index ["name", "project_id"], name: "index_easy_settings_on_name_and_project_id", unique: true
    t.index ["project_id"], name: "index_easy_settings_on_project_id"
  end

  create_table "email_addresses", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "address", null: false
    t.boolean "is_default", default: false, null: false
    t.boolean "notify", default: true, null: false
    t.datetime "created_on", null: false
    t.datetime "updated_on", null: false
    t.index ["user_id"], name: "index_email_addresses_on_user_id"
  end

  create_table "enabled_modules", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "project_id"
    t.string "name", null: false
    t.index ["project_id"], name: "enabled_modules_project_id"
  end

  create_table "enumerations", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "name", limit: 30, default: "", null: false
    t.integer "position"
    t.boolean "is_default", default: false, null: false
    t.string "type"
    t.boolean "active", default: true, null: false
    t.integer "project_id"
    t.integer "parent_id"
    t.string "position_name", limit: 30
    t.index ["id", "type"], name: "index_enumerations_on_id_and_type"
    t.index ["project_id"], name: "index_enumerations_on_project_id"
  end

  create_table "favorite_projects", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "project_id"
    t.integer "user_id"
    t.index ["project_id", "user_id"], name: "index_favorite_projects_on_project_id_and_user_id"
  end

  create_table "favorite_projects_templates", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "name"
    t.integer "visibility", default: 0
    t.text "template"
    t.text "description"
    t.integer "owner_id"
    t.index ["owner_id"], name: "index_favorite_projects_templates_on_owner_id"
  end

  create_table "groups_users", id: false, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "group_id", null: false
    t.integer "user_id", null: false
    t.index ["group_id", "user_id"], name: "groups_users_ids", unique: true
  end

  create_table "helpdesk_mail_rules", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "mail_type"
    t.text "conditions"
    t.text "actions"
    t.integer "user_id", null: false
    t.integer "position", default: 0
  end

  create_table "helpdesk_tickets", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "contact_id"
    t.integer "issue_id"
    t.integer "source", default: 0, null: false
    t.string "from_address"
    t.string "to_address"
    t.datetime "ticket_date"
    t.string "cc_address"
    t.string "message_id"
    t.boolean "is_incoming", default: true
    t.integer "reaction_time"
    t.integer "first_response_time"
    t.integer "resolve_time"
    t.datetime "last_agent_response_at"
    t.datetime "last_customer_response_at"
    t.integer "vote"
    t.string "vote_comment"
    t.string "view_id"
    t.datetime "viewed_on"
    t.index ["issue_id", "contact_id"], name: "index_helpdesk_tickets_on_issue_id_and_contact_id"
    t.index ["message_id"], name: "index_helpdesk_tickets_on_message_id"
  end

  create_table "import_items", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "import_id", null: false
    t.integer "position", null: false
    t.integer "obj_id"
    t.text "message"
    t.string "unique_id"
    t.index ["import_id", "unique_id"], name: "index_import_items_on_import_id_and_unique_id"
  end

  create_table "imports", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "type"
    t.integer "user_id", null: false
    t.string "filename"
    t.text "settings"
    t.integer "total_items"
    t.boolean "finished", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "issue_categories", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "project_id", default: 0, null: false
    t.string "name", limit: 60, default: "", null: false
    t.integer "assigned_to_id"
    t.index ["assigned_to_id"], name: "index_issue_categories_on_assigned_to_id"
    t.index ["project_id"], name: "issue_categories_project_id"
  end

  create_table "issue_relations", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "issue_from_id", null: false
    t.integer "issue_to_id", null: false
    t.string "relation_type", default: "", null: false
    t.integer "delay"
    t.index ["issue_from_id", "issue_to_id"], name: "index_issue_relations_on_issue_from_id_and_issue_to_id", unique: true
    t.index ["issue_from_id"], name: "index_issue_relations_on_issue_from_id"
    t.index ["issue_to_id"], name: "index_issue_relations_on_issue_to_id"
  end

  create_table "issue_statuses", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "name", limit: 30, default: "", null: false
    t.boolean "is_closed", default: false, null: false
    t.integer "position"
    t.integer "default_done_ratio"
    t.index ["is_closed"], name: "index_issue_statuses_on_is_closed"
    t.index ["position"], name: "index_issue_statuses_on_position"
  end

  create_table "issues", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "tracker_id", null: false
    t.integer "project_id", null: false
    t.string "subject", default: "", null: false
    t.text "description", size: :long
    t.date "due_date"
    t.integer "category_id"
    t.integer "status_id", null: false
    t.integer "assigned_to_id"
    t.integer "priority_id", null: false
    t.integer "fixed_version_id"
    t.integer "author_id", null: false
    t.integer "lock_version", default: 0, null: false
    t.timestamp "created_on"
    t.timestamp "updated_on"
    t.date "start_date"
    t.integer "done_ratio", default: 0, null: false
    t.float "estimated_hours"
    t.integer "parent_id"
    t.integer "root_id"
    t.integer "lft"
    t.integer "rgt"
    t.boolean "is_private", default: false, null: false
    t.datetime "closed_on"
    t.index ["assigned_to_id"], name: "index_issues_on_assigned_to_id"
    t.index ["author_id"], name: "index_issues_on_author_id"
    t.index ["category_id"], name: "index_issues_on_category_id"
    t.index ["created_on"], name: "index_issues_on_created_on"
    t.index ["fixed_version_id"], name: "index_issues_on_fixed_version_id"
    t.index ["parent_id"], name: "index_issues_on_parent_id"
    t.index ["priority_id"], name: "index_issues_on_priority_id"
    t.index ["project_id"], name: "issues_project_id"
    t.index ["root_id", "lft", "rgt"], name: "index_issues_on_root_id_and_lft_and_rgt"
    t.index ["status_id"], name: "index_issues_on_status_id"
    t.index ["tracker_id"], name: "index_issues_on_tracker_id"
  end

  create_table "journal_details", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "journal_id", default: 0, null: false
    t.string "property", limit: 30, default: "", null: false
    t.string "prop_key", limit: 30, default: "", null: false
    t.text "old_value", size: :long
    t.text "value", size: :long
    t.index ["journal_id"], name: "journal_details_journal_id"
  end

  create_table "journal_messages", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "contact_id"
    t.integer "journal_id"
    t.boolean "is_incoming"
    t.integer "source", default: 0, null: false
    t.string "from_address"
    t.string "to_address"
    t.string "bcc_address"
    t.string "cc_address"
    t.datetime "message_date"
    t.string "message_id"
    t.string "view_id"
    t.datetime "viewed_on"
    t.index ["journal_id", "contact_id"], name: "index_journal_messages_on_journal_id_and_contact_id"
    t.index ["message_id"], name: "index_journal_messages_on_message_id"
  end

  create_table "journals", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "journalized_id", default: 0, null: false
    t.string "journalized_type", limit: 30, default: "", null: false
    t.integer "user_id", default: 0, null: false
    t.text "notes", size: :long
    t.datetime "created_on", null: false
    t.boolean "private_notes", default: false, null: false
    t.index ["created_on"], name: "index_journals_on_created_on"
    t.index ["journalized_id", "journalized_type"], name: "journals_journalized_id"
    t.index ["journalized_id"], name: "index_journals_on_journalized_id"
    t.index ["user_id"], name: "index_journals_on_user_id"
  end

  create_table "member_roles", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "member_id", null: false
    t.integer "role_id", null: false
    t.integer "inherited_from"
    t.index ["inherited_from"], name: "index_member_roles_on_inherited_from"
    t.index ["member_id"], name: "index_member_roles_on_member_id"
    t.index ["role_id"], name: "index_member_roles_on_role_id"
  end

  create_table "members", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "user_id", default: 0, null: false
    t.integer "project_id", default: 0, null: false
    t.timestamp "created_on"
    t.boolean "mail_notification", default: false, null: false
    t.boolean "dmsf_mail_notification"
    t.text "dmsf_title_format", size: :tiny
    t.boolean "dmsf_fast_links", default: false, null: false
    t.index ["project_id"], name: "index_members_on_project_id"
    t.index ["user_id", "project_id"], name: "index_members_on_user_id_and_project_id", unique: true
    t.index ["user_id"], name: "index_members_on_user_id"
  end

  create_table "messages", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "board_id", null: false
    t.integer "parent_id"
    t.string "subject", default: "", null: false
    t.text "content"
    t.integer "author_id"
    t.integer "replies_count", default: 0, null: false
    t.integer "last_reply_id"
    t.datetime "created_on", null: false
    t.datetime "updated_on", null: false
    t.boolean "locked", default: false
    t.integer "sticky", default: 0
    t.index ["author_id"], name: "index_messages_on_author_id"
    t.index ["board_id"], name: "messages_board_id"
    t.index ["created_on"], name: "index_messages_on_created_on"
    t.index ["last_reply_id"], name: "index_messages_on_last_reply_id"
    t.index ["parent_id"], name: "messages_parent_id"
  end

  create_table "news", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "project_id"
    t.string "title", limit: 60, default: "", null: false
    t.string "summary", default: ""
    t.text "description"
    t.integer "author_id", default: 0, null: false
    t.timestamp "created_on"
    t.integer "comments_count", default: 0, null: false
    t.index ["author_id"], name: "index_news_on_author_id"
    t.index ["created_on"], name: "index_news_on_created_on"
    t.index ["project_id"], name: "news_project_id"
  end

  create_table "notes", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "subject"
    t.text "content"
    t.integer "source_id"
    t.string "source_type"
    t.integer "author_id"
    t.datetime "created_on"
    t.datetime "updated_on"
    t.integer "type_id"
    t.index ["author_id"], name: "index_notes_on_author_id"
    t.index ["source_id", "source_type"], name: "index_notes_on_source_id_and_source_type"
    t.index ["type_id"], name: "index_notes_on_type_id"
  end

  create_table "projects", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.text "description"
    t.string "homepage", default: ""
    t.boolean "is_public", default: true, null: false
    t.integer "parent_id"
    t.timestamp "created_on"
    t.timestamp "updated_on"
    t.string "identifier"
    t.integer "status", default: 1, null: false
    t.integer "lft"
    t.integer "rgt"
    t.boolean "inherit_members", default: false, null: false
    t.integer "default_version_id"
    t.integer "default_assigned_to_id"
    t.integer "default_issue_query_id"
    t.boolean "rx_project_template", default: false
    t.string "rx_resources_distribution", default: "default", null: false
    t.text "dmsf_description"
    t.boolean "dmsf_notification", default: false
    t.integer "dmsf_act_as_attachable", default: 1, null: false
    t.integer "default_dmsf_query_id"
    t.text "new_ticket_message"
    t.integer "enable_new_ticket_message", default: 1, null: false
    t.index ["lft"], name: "index_projects_on_lft"
    t.index ["rgt"], name: "index_projects_on_rgt"
  end

  create_table "projects_trackers", id: false, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "project_id", default: 0, null: false
    t.integer "tracker_id", default: 0, null: false
    t.index ["project_id", "tracker_id"], name: "projects_trackers_unique", unique: true
    t.index ["project_id"], name: "projects_trackers_project_id"
  end

  create_table "queries", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "project_id"
    t.string "name", default: "", null: false
    t.text "filters"
    t.integer "user_id", default: 0, null: false
    t.text "column_names"
    t.text "sort_criteria"
    t.string "group_by"
    t.string "type"
    t.integer "visibility", default: 0
    t.text "options"
    t.index ["project_id"], name: "index_queries_on_project_id"
    t.index ["user_id"], name: "index_queries_on_user_id"
  end

  create_table "queries_roles", id: false, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "query_id", null: false
    t.integer "role_id", null: false
    t.index ["query_id", "role_id"], name: "queries_roles_ids", unique: true
  end

  create_table "repositories", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "project_id", default: 0, null: false
    t.string "url", default: "", null: false
    t.string "login", limit: 60, default: ""
    t.string "password", default: ""
    t.string "root_url", default: ""
    t.string "type"
    t.string "path_encoding", limit: 64
    t.string "log_encoding", limit: 64
    t.text "extra_info", size: :long
    t.string "identifier"
    t.boolean "is_default", default: false
    t.timestamp "created_on"
    t.index ["project_id"], name: "index_repositories_on_project_id"
  end

  create_table "rich_rich_files", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "rich_file_file_name"
    t.string "rich_file_content_type"
    t.integer "rich_file_file_size"
    t.datetime "rich_file_updated_at"
    t.string "owner_type"
    t.integer "owner_id"
    t.text "uri_cache"
    t.string "simplified_type", default: "file"
  end

  create_table "roles", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.integer "position"
    t.boolean "assignable", default: true
    t.integer "builtin", default: 0, null: false
    t.text "permissions"
    t.string "issues_visibility", limit: 30, default: "default", null: false
    t.string "users_visibility", limit: 30, default: "all", null: false
    t.string "time_entries_visibility", limit: 30, default: "all", null: false
    t.boolean "all_roles_managed", default: true, null: false
    t.text "settings"
    t.boolean "hide", default: false, null: false
  end

  create_table "roles_managed_roles", id: false, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "role_id", null: false
    t.integer "managed_role_id", null: false
    t.index ["role_id", "managed_role_id"], name: "index_roles_managed_roles_on_role_id_and_managed_role_id", unique: true
  end

  create_table "rx_country_holidays", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "country"
    t.string "country_iso"
    t.string "holiday_type"
    t.date "date"
    t.integer "year"
    t.string "name"
    t.string "state"
    t.string "state_iso"
  end

  create_table "rx_fixed_values", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.float "hours", null: false
    t.date "date", null: false
    t.integer "author_id", null: false
    t.bigint "issue_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date"], name: "index_rx_fixed_values_on_date"
    t.index ["issue_id"], name: "index_rx_fixed_values_on_issue_id"
  end

  create_table "rx_statistics_charts", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "rx_statistics_grid_id"
    t.string "name"
    t.string "chart_type"
    t.date "from"
    t.date "to"
    t.string "interval"
    t.string "interval_type"
    t.string "unit"
    t.string "datasets"
    t.text "options"
    t.integer "color_palette", default: 0
    t.string "chart_group", default: "projects", null: false
    t.string "chart_settings"
    t.index ["rx_statistics_grid_id"], name: "index_rx_statistics_charts_on_rx_statistics_grid_id"
  end

  create_table "rx_statistics_grids", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "user_id"
    t.integer "project_id"
    t.string "grid_type", null: false
    t.text "data"
    t.index ["project_id"], name: "index_rx_statistics_grids_on_project_id"
    t.index ["user_id"], name: "index_rx_statistics_grids_on_user_id"
  end

  create_table "settings", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.text "value"
    t.timestamp "updated_on"
    t.index ["name"], name: "index_settings_on_name"
  end

  create_table "taggings", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "tag_id"
    t.integer "taggable_id"
    t.string "taggable_type"
    t.datetime "created_at"
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type"], name: "index_taggings_on_taggable_id_and_taggable_type"
  end

  create_table "tags", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "name"
  end

  create_table "time_entries", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "project_id", null: false
    t.integer "author_id"
    t.integer "user_id", null: false
    t.integer "issue_id"
    t.float "hours", null: false
    t.string "comments", limit: 1024
    t.integer "activity_id", null: false
    t.date "spent_on", null: false
    t.integer "tyear", null: false
    t.integer "tmonth", null: false
    t.integer "tweek", null: false
    t.datetime "created_on", null: false
    t.datetime "updated_on", null: false
    t.index ["activity_id"], name: "index_time_entries_on_activity_id"
    t.index ["created_on"], name: "index_time_entries_on_created_on"
    t.index ["issue_id"], name: "time_entries_issue_id"
    t.index ["project_id"], name: "time_entries_project_id"
    t.index ["user_id"], name: "index_time_entries_on_user_id"
  end

  create_table "tokens", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "user_id", default: 0, null: false
    t.string "action", limit: 30, default: "", null: false
    t.string "value", limit: 40, default: "", null: false
    t.datetime "created_on", null: false
    t.timestamp "updated_on"
    t.index ["user_id"], name: "index_tokens_on_user_id"
    t.index ["value"], name: "tokens_value", unique: true
  end

  create_table "trackers", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "name", limit: 30, default: "", null: false
    t.string "description"
    t.integer "position"
    t.boolean "is_in_roadmap", default: true, null: false
    t.integer "fields_bits", default: 0
    t.integer "default_status_id"
  end

  create_table "user_preferences", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "user_id", default: 0, null: false
    t.text "others"
    t.boolean "hide_mail", default: true
    t.string "time_zone"
    t.index ["user_id"], name: "index_user_preferences_on_user_id"
  end

  create_table "users", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "login", default: "", null: false
    t.string "hashed_password", limit: 40, default: "", null: false
    t.string "firstname", limit: 30, default: "", null: false
    t.string "lastname", default: "", null: false
    t.boolean "admin", default: false, null: false
    t.integer "status", default: 1, null: false
    t.datetime "last_login_on"
    t.string "language", limit: 5, default: ""
    t.integer "auth_source_id"
    t.timestamp "created_on"
    t.timestamp "updated_on"
    t.string "type"
    t.string "mail_notification", default: "", null: false
    t.string "salt", limit: 64
    t.boolean "must_change_passwd", default: false, null: false
    t.datetime "passwd_changed_on"
    t.string "twofa_scheme"
    t.string "twofa_totp_key"
    t.integer "twofa_totp_last_used_at"
    t.boolean "twofa_required", default: false
    t.index ["auth_source_id"], name: "index_users_on_auth_source_id"
    t.index ["id", "type"], name: "index_users_on_id_and_type"
    t.index ["type"], name: "index_users_on_type"
  end

  create_table "versions", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "project_id", default: 0, null: false
    t.string "name", default: "", null: false
    t.string "description", default: ""
    t.date "effective_date"
    t.timestamp "created_on"
    t.timestamp "updated_on"
    t.string "wiki_page_title"
    t.string "status", default: "open"
    t.string "sharing", default: "none", null: false
    t.index ["project_id"], name: "versions_project_id"
    t.index ["sharing"], name: "index_versions_on_sharing"
  end

  create_table "watchers", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "watchable_type", default: "", null: false
    t.integer "watchable_id", default: 0, null: false
    t.integer "user_id"
    t.index ["user_id", "watchable_type"], name: "watchers_user_id_type"
    t.index ["user_id"], name: "index_watchers_on_user_id"
    t.index ["watchable_id", "watchable_type"], name: "index_watchers_on_watchable_id_and_watchable_type"
  end

  create_table "wiki_content_versions", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "wiki_content_id", null: false
    t.integer "page_id", null: false
    t.integer "author_id"
    t.binary "data", size: :long
    t.string "compression", limit: 6, default: ""
    t.string "comments", limit: 1024, default: ""
    t.datetime "updated_on", null: false
    t.integer "version", null: false
    t.index ["updated_on"], name: "index_wiki_content_versions_on_updated_on"
    t.index ["wiki_content_id"], name: "wiki_content_versions_wcid"
  end

  create_table "wiki_contents", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "page_id", null: false
    t.integer "author_id"
    t.text "text", size: :long
    t.string "comments", limit: 1024, default: ""
    t.datetime "updated_on", null: false
    t.integer "version", null: false
    t.index ["author_id"], name: "index_wiki_contents_on_author_id"
    t.index ["page_id"], name: "wiki_contents_page_id"
  end

  create_table "wiki_pages", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "wiki_id", null: false
    t.string "title", null: false
    t.datetime "created_on", null: false
    t.boolean "protected", default: false, null: false
    t.integer "parent_id"
    t.index ["parent_id"], name: "index_wiki_pages_on_parent_id"
    t.index ["wiki_id", "title"], name: "wiki_pages_wiki_id_title"
    t.index ["wiki_id"], name: "index_wiki_pages_on_wiki_id"
  end

  create_table "wiki_redirects", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "wiki_id", null: false
    t.string "title"
    t.string "redirects_to"
    t.datetime "created_on", null: false
    t.integer "redirects_to_wiki_id", null: false
    t.index ["wiki_id", "title"], name: "wiki_redirects_wiki_id_title"
    t.index ["wiki_id"], name: "index_wiki_redirects_on_wiki_id"
  end

  create_table "wikis", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "project_id", null: false
    t.string "start_page", null: false
    t.integer "status", default: 1, null: false
    t.index ["project_id"], name: "wikis_project_id"
  end

  create_table "workflows", id: :integer, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "tracker_id", default: 0, null: false
    t.integer "old_status_id", default: 0, null: false
    t.integer "new_status_id", default: 0, null: false
    t.integer "role_id", default: 0, null: false
    t.boolean "assignee", default: false, null: false
    t.boolean "author", default: false, null: false
    t.string "type", limit: 30
    t.string "field_name", limit: 30
    t.string "rule", limit: 30
    t.index ["new_status_id"], name: "index_workflows_on_new_status_id"
    t.index ["old_status_id"], name: "index_workflows_on_old_status_id"
    t.index ["role_id", "tracker_id", "old_status_id"], name: "wkfs_role_tracker_old_status"
    t.index ["role_id"], name: "index_workflows_on_role_id"
    t.index ["tracker_id"], name: "index_workflows_on_tracker_id"
  end

  add_foreign_key "dashboard_roles", "dashboards", on_delete: :cascade
  add_foreign_key "dashboard_roles", "roles", on_delete: :cascade
  add_foreign_key "dashboards", "projects", on_delete: :cascade
  add_foreign_key "dashboards", "users", column: "author_id", on_delete: :cascade
end
