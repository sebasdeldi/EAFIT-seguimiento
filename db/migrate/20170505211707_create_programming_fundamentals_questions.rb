class CreateProgrammingFundamentalsQuestions < ActiveRecord::Migration[5.0]
  def change
    create_table :programming_fundamentals_questions do |t|
      t.integer :numeric_calification
      t.references :subject, foreign_key: true
      t.integer :student_id
      t.integer :teacher_id
      t.string :black_box
      t.string :pseudocode
      t.string :diagrams
      t.string :modularity
      t.string :sequences
      t.string :desitions
      t.string :loops
      t.string :functions
      t.string :data_structures
      t.string :abstraction
      t.string :encapsulation
      t.string :inheritance
      t.string :polymorphism
      t.string :class_diagrams
      t.string :implementation
      t.string :testing

      t.timestamps
    end
  end
end
