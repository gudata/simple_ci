class CreateRepositories < ActiveRecord::Migration
  def change
    create_table :repositories, force: true do |t|
      t.string :name
      t.string :path
      t.string :image_uid
      t.string :git, default: 'git'

      t.string   "email_recipients",         default: "",    null: false
      t.timestamps
    end

    create_table :branches, force: true do |t|
      t.belongs_to :repository
      t.string :name
      t.string :image_uid
      t.string :canonical_name
      t.string :tip_oid
      t.boolean :build
      t.string   "token"
      t.integer  "polling_interval"
      t.timestamps
    end

    create_table :scripts, force: true do |t|
      t.belongs_to :branch
      t.string :name
      t.text :body
      t.integer  "timeout",                  default: 1800,  null: false
      t.timestamps
    end

    create_table :commits, force: true do |t|
      t.belongs_to :branch
      t.integer :committer_id
      t.integer :author_id
      t.string :oid, index: true
      t.string :image_uid
      t.text :message
      t.datetime :time

      t.timestamps
    end


    create_table :developers, force: true do |t|
      t.string :email
      t.string :name
      t.string :image_uid
      t.timestamps
    end


    create_table "builds", force: true do |t|
      t.belongs_to :commit
      t.string   :oid, index: true
      t.integer   :state
      t.datetime :started_at
      t.datetime :finished_at
      t.text     :push_data,   limit: 16777215
      t.text     :trace,       limit: 2147483647

      t.string   :before_oid
      t.string   :tmp_file
      t.integer  :pid

      t.timestamps
    end


  end
end
