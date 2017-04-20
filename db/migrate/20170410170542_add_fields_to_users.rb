class AddFieldsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :names, :string
    add_column :users, :last_names, :string
    add_column :users, :highschool, :string
    add_column :users, :highschool_type, :string
    add_column :users, :technical_education, :string
    add_column :users, :origin_municipality, :string
    add_column :users, :address, :string
    add_column :users, :living_municipality, :string
    add_column :users, :living_neighbourhood, :string
    add_column :users, :scolarship, :string
    add_column :users, :computer_access, :string
    add_column :users, :code, :string
    add_column :users, :role, :string
  end
end
