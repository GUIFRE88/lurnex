class CreateCourses < ActiveRecord::Migration[8.1]
  def change
    create_table :courses do |t|
      t.references :organization, null: false, foreign_key: true
      t.string :title, null: false
      t.text :description

      t.timestamps
    end

    add_index :courses, [ :organization_id, :title ]
  end
end
