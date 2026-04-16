class CreateInvites < ActiveRecord::Migration[8.1]
  def change
    create_table :invites do |t|
      t.references :organization, null: false, foreign_key: true
      t.references :invited_by_membership, null: false, foreign_key: { to_table: :memberships }
      t.string :email_address, null: false
      t.integer :role, null: false, default: 1
      t.string :token, null: false
      t.datetime :accepted_at

      t.timestamps
    end

    add_index :invites, :token, unique: true
    add_index :invites, [ :organization_id, :email_address, :accepted_at ], name: "index_invites_org_email_accepted"
  end
end
