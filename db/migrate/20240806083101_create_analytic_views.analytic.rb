# frozen_string_literal: true

# This migration comes from analytic (originally 20240805210911)
class CreateAnalyticViews < ActiveRecord::Migration[7.1]
  def change
    create_table :analytic_views do |t|
      t.uuid :visitor_id, null: false
      t.uuid :session_id, null: false
      t.inet :ip, null: false
      t.string :path, null: false
      t.string :host, null: false
      t.jsonb :params, null: false, default: {}
      t.text :referrer, null: true
      t.text :user_agent, null: true
      t.datetime :timestamp, null: false

      t.timestamps

      t.index %i[timestamp path]
      t.index %i[timestamp visitor_id]
      t.index %i[timestamp session_id]
      t.index %i[timestamp referrer]
    end
  end
end
