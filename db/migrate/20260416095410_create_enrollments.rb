class CreateEnrollments < ActiveRecord::Migration[8.1]
  def change
    create_table :enrollments do |t|
      t.references :organization, null: false, foreign_key: true
      t.references :course, null: false, foreign_key: true
      t.references :membership, null: false, foreign_key: true

      t.timestamps
    end

    add_index :enrollments, [ :course_id, :membership_id ], unique: true
  end
end
