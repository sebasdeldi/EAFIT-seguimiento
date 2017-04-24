class CreateSwDevPrinciplesQuestions < ActiveRecord::Migration[5.0]
  def change
    create_table :sw_dev_principles_questions do |t|
      t.integer :numeric_calification
      t.references :subject, foreign_key: true
      t.integer :student_id
      t.integer :teacher_id
      t.string :arguments_presentation
      t.string :diagram_structure
      t.string :objective_presentation
      t.string :problem_solution
      t.string :case_use_diagrams
      t.string :class_diagrams
      t.string :secuence_diagrams

      t.timestamps
    end
  end
end
