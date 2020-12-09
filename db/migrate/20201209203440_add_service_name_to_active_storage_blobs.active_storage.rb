# This migration comes from active_storage (originally 20190112182829)
class AddServiceNameToActiveStorageBlobs < ActiveRecord::Migration[6.0]
  def up
    add_column :active_storage_blobs, :service_name, :string

    execute <<~SQL
      UPDATE "active_storage_blobs" SET "service_name" = '#{ActiveStorage::Blob.service.name}';
    SQL

    change_column :active_storage_blobs, :service_name, :string, null: false
  end

  def down
    remove_column :active_storage_blobs, :service_name
  end
end
