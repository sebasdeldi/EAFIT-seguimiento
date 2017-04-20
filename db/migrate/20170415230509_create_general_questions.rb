class CreateGeneralQuestions < ActiveRecord::Migration[5.0]
  def change
    create_table :general_questions do |t|
      t.string :class_assistance
      t.string :class_participation
      t.string :class_orders_following
      t.integer :numeric_calification
      t.references :subject, foreign_key: true
      t.integer :student_id, foreign_key: true
      t.integer :teacher_id, foreign_key: true

      t.timestamps
    end
  end
end
