class AddClavisManifestationId < ActiveRecord::Migration
  def change
    add_column :journals, :clavis_manifestation_id, :integer
  end
end
