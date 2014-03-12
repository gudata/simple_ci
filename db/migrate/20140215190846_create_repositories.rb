class CreateRepositories < ActiveRecord::Migration
  def change
    create_table :repositories, force: true do |t|
      t.string :name
      t.string :path
      t.string :image_uid
      t.string :git, default: 'git'
      t.integer :display_order, default: 100
      t.integer :fetch_interval, default: 60
      t.boolean :auto_fetch
      t.datetime :last_fetch

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
      t.integer  :state, index: true

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
      t.boolean :can_login, default: true
      t.string :password_digest
      t.string :image_uid
      t.timestamps
    end

    create_table "builds", force: true do |t|
      t.belongs_to :commit
      t.belongs_to :repository
      t.string   :oid, index: true
      t.integer  :state, index: true
      t.datetime :started_at, index: true
      t.datetime :finished_at, index: true
      t.string   :total_time, index: true

      t.text     :output,       limit: 2147483647

      t.timestamps
    end



  end
end
