class CreateCourseProgresses < ActiveRecord::Migration[8.1]
  def change
    create_table :course_progresses do |t|
      t.references :enrollment, null: false, foreign_key: true
      t.integer :percentage, null: false, default: 0
      t.datetime :completed_at

      t.timestamps
    end

  end
end
